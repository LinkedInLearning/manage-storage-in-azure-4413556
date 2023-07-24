// Creates a storage account and a VM in a VNet
@description('Azure region of the deployment')
param location string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Username for the Virtual Machine.')
param adminUsername string = 'admin0405'

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

var blobPrivateDnsZoneName = 'privatelink.blob.${environment().suffixes.storage}'

var storagePleBlobName = 'ple-sa-${resourceSuffix}-blob'

module network 'network.bicep' = {
  name: 'vnet-${resourceSuffix}'
  params: {
    location: location
    suffix: resourceSuffix
    addressPrefix: '10.0.0.0/16'
    subnetPrefix: '10.0.0.0/24'
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
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    isHnsEnabled: false
    isNfsV3Enabled: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    publicNetworkAccess: 'Disabled'
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
  }
  resource secondContainer 'containers' = {
    name: 'json'
  }
}

resource storagePrivateEndpointBlob 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: storagePleBlobName
  location: location
    properties: {
    privateLinkServiceConnections: [
      { 
        name: storagePleBlobName
        properties: {
          groupIds: [
            'blob'
          ]
          privateLinkServiceId: storage.id
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    subnet: {
      id: network.outputs.subnetId
    }
  }
}

resource blobPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: blobPrivateDnsZoneName
  location: 'global'
}

resource privateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = {
  name: 'blob-PrivateDnsZoneGroup'
  parent: storagePrivateEndpointBlob
  properties:{
    privateDnsZoneConfigs: [
      {
        name: blobPrivateDnsZoneName
        properties:{
          privateDnsZoneId: blobPrivateDnsZone.id
        }
      }
    ]
  }
}

resource blobPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: uniqueString(storage.id)
  parent: blobPrivateDnsZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: network.outputs.VNetId
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
    subnetName: network.outputs.subnetName
    virtualNetworkName: network.outputs.VNetName
  }
  dependsOn: [
    network
  ]
}

output hostname string = vmwindows.outputs.hostname
