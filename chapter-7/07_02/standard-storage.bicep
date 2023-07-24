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

@description('Azure region where resources will be deployed')
param location string

var uniqueStorageName = 'sa${resourceSuffix}${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
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

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storage
  properties: {
    containerDeleteRetentionPolicy: {
      days: 7
      enabled: false
    }
    deleteRetentionPolicy: {
      days: 7
      enabled: false
    }
    isVersioningEnabled: false
  }

  resource containerBlobDemo 'containers' = {
    name: 'accesstiers'
  }
}

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  name: 'default'
  parent: storage
}

resource hotshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  name: 'hottier'
  parent: fileService
  properties: {
    shareQuota: 100 //This is GB
    enabledProtocols: 'SMB'
   accessTier: 'Hot'
  }
}

resource transoptshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  name: 'transoptier'
  parent: fileService
  properties: {
    shareQuota: 100 //This is GB
    enabledProtocols: 'SMB'
   accessTier:'TransactionOptimized'
  }
}

output storageEndpoint object = storage.properties.primaryEndpoints
