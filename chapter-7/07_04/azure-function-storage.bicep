@description('Allowed values for storageSKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_ZRS'

@description('Azure region where resources will be deployed, pulled from resourceGroup')
param location string

@description('Prefix for the storage account')
@maxLength(13)
param storagePrefix string = 'sapyfa'

resource stg 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${storagePrefix}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
}

output stgName string = stg.name
