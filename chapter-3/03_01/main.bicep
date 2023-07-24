// Creates a storage account two networks and a VM in one of the networks
@description('Azure region of the deployment')
param location string

@description('Azure region of the deployment')
param secondLocation string = 'eastasia'

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Username for the Virtual Machine.')
param adminUsername string = 'admin0301'

@description('Storage prefix for the file share storage account')
@maxLength(4)
param resourceSuffix string


@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
])

@description('Storage SKU')
param storageSkuName string = 'Standard_LRS'

var storageName = 'sa${resourceSuffix}${uniqueString(resourceGroup().id)}'


module network 'network.bicep' = {
  name: 'vnet-${resourceSuffix}'
  params: {
    location: location
    suffix: resourceSuffix
    addressPrefix: '10.0.0.0/16'
    subnetPrefix: '10.0.0.0/24'
  }
}

module secondNetwork 'network.bicep' = {
  name: 'vnet-ne-${resourceSuffix}'
  params: {
    location: secondLocation
    addressPrefix: '10.1.0.0/16'
    subnetPrefix: '10.1.0.0/24'
    suffix: 'ne${resourceSuffix}'
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageName
  location: location
  sku: {
    name: storageSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    isHnsEnabled: false
    isNfsV3Enabled: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storage
  properties: {
    containerDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
    deleteRetentionPolicy: {
      days: 7
      enabled: true
    }
    isVersioningEnabled: true
    changeFeed: {
        enabled: true
    }
  }

  resource firstContainer 'containers' = {
    name: 'text'
    properties: {
      publicAccess : 'Container'
    }
  }
  resource secondContainer 'containers' = {
    name: 'json'
    properties: {
      publicAccess : 'Container'
    }
  }
}

module vmwindows 'vm-windows.bicep' = {
  name: 'vm-windows'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    location: location
    resourceSuffix: resourceSuffix
    subnetName: network.outputs.workloadSubnetName
    virtualNetworkName: network.outputs.workloadVNetName
  }
  dependsOn: [
    network
  ]
}


resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript-upload-blob'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: storage.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storage.listKeys().keys[0].value
      }
      {
        name: 'TXTCONTENT'
        value: loadTextContent('data/blobs/blob1.txt')
      }
      {
        name: 'JSONCONTENT'
        value: loadTextContent('data/blobs/blob2.json')
      }
    ]
    scriptContent: '''
                        echo "$TXTCONTENT" > blob1.txt
                        echo "$JSONCONTENT" > blob2.json

                        az storage blob upload --file blob1.txt --container-name text --name blob1.txt

                        az storage blob upload --file blob1.txt --container-name text --name blob2.txt

                        az storage blob upload --file blob2.json --container-name json --name blob1.json

                        az storage blob upload --file blob2.json --container-name json --name blob2.json
                  '''
  }
}
