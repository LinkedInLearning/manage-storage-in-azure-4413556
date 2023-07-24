@description('Static prefix for the storage account')
@minLength(3)
@maxLength(9)
param resourceSuffix string

@description('Allowed values for storageSKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

@description('Azure region where source resources will be deployed')
param location string 

@description('Azure region where cross region account will be deployed')
param crossLocation string = 'eastasia'

var uniqueStorageName = 'sa${resourceSuffix}${uniqueString(resourceGroup().id)}'
var uniqueCrossName = 'sacross${uniqueString(resourceGroup().id)}'
var uniqueSameName = 'sasame${uniqueString(resourceGroup().id)}'

resource sourceStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  properties: {
    allowBlobPublicAccess: true
  }
  kind: 'StorageV2'
}

resource crossRegion 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: uniqueCrossName
  location: crossLocation
  sku: {
    name: storageSKU
  }
  properties: {
    allowBlobPublicAccess: true
  }
  kind: 'StorageV2'
}

resource sameRegion 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: uniqueSameName
  location: location
  sku: {
    name: storageSKU
  }
  properties: {
    allowBlobPublicAccess: true
  }
  kind: 'StorageV2'
}

resource sourceBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: sourceStorage
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

resource crossRegionBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: crossRegion
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
  }

  resource firstContainer 'containers' = {
    name: 'textcrossregion'
    properties: {
      publicAccess : 'Container'
    }
  }
  resource secondContainer 'containers' = {
    name: 'jsoncrossregion'
    properties: {
      publicAccess : 'Container'
    }
  }
}

resource sameRegionBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: sameRegion
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
  }

  resource firstContainer 'containers' = {
    name: 'textsameregion'
    properties: {
      publicAccess : 'Container'
    }
  }
  resource secondContainer 'containers' = {
    name: 'jsonsameregion'
    properties: {
      publicAccess : 'Container'
    }
  }
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
        value: sourceStorage.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: sourceStorage.listKeys().keys[0].value
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

                        az storage blob upload --file blob1.txt --container-name text --name 'cross/blob1.txt'

                        az storage blob upload --file blob1.txt --container-name text --name 'same/blob2.txt'

                        az storage blob upload --file blob2.json --container-name json --name 'cross/blob1.json'

                        az storage blob upload --file blob2.json --container-name json --name 'same/blob2.json'
                  '''
  }
}

output storageEndpoint object = sourceStorage.properties.primaryEndpoints
