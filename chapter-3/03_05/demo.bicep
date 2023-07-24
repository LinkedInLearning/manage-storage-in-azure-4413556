
@description('Specifies the location for resources.')
param location string = 'uksouth'

 resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'sa0305bicep'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
 }
