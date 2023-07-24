// Creates a storage account, private endpoints and DNS zones, virtual Network and Virtual Machine
@description('Azure region of the deployment')
param location string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Username for the Virtual Machine.')
param adminUsername string = 'admin0503'

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
param storageSkuName string = 'Premium_LRS'

var storageName = 'sa${resourceSuffix}${uniqueString(resourceGroup().id)}'

var filePrivateDnsZoneName = 'privatelink.file.${environment().suffixes.storage}'

module network 'network.bicep' = {
  name: 'vnet-${resourceSuffix}'
  params: {
    location: location
    suffix: resourceSuffix
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageName
  location: location
  sku: {
    name: storageSkuName
  }
  kind: 'FileStorage'
  properties: {
    allowSharedKeyAccess: true
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: false
      services: {
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    isHnsEnabled: false
    isNfsV3Enabled: false
    keyPolicy: {
      keyExpirationPeriodInDays: 7
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: false
  }
}

resource storagePrivateEndpointFile 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'plf-${storage.name}'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'plf-${storage.name}'
        properties: {
          groupIds: [
            'file'
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

resource filePrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: filePrivateDnsZoneName
  location: 'global'
}

resource filePrivateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = {
  name: storage.name
  parent: storagePrivateEndpointFile
  properties:{
    privateDnsZoneConfigs: [
      {
        name: filePrivateDnsZoneName
        properties:{
          privateDnsZoneId: filePrivateDnsZone.id
        }
      }
    ]
  }
}

resource filePrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'vnet-${resourceSuffix}-link'
  parent: filePrivateDnsZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: network.outputs.vnetId
    }
  }
}

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2021-08-01' = {
  name: 'default'
  parent: storage
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-08-01' = {
  name: 'nfsmount'
  parent: fileService
  properties: {
    enabledProtocols: 'NFS'
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
    virtualNetworkName: network.outputs.vnetName
  }
  dependsOn: [
    network
  ]
}


module vmlinux 'vm-linux-ubuntu.bicep' = {
  name: 'vm-linux'
  params: {
    location: location
    adminPasswordOrKey: adminPassword
    adminUsername: adminUsername
    subnetName: network.outputs.subnetName
    virtualNetworkName: network.outputs.vnetName
    resourceSuffix: resourceSuffix
  }
  dependsOn: [
    network
  ]
}
