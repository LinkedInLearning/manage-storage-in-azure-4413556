@description('Static type suffix for the storage resources')
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


module storage 'standard-storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    resourceSuffix:resourceSuffix
    storageSKU: storageSKU
  }
}

module keyvault 'keyvault-key.bicep' = {
  name: 'keyvault'
  params: {
    resourceSuffix: resourceSuffix
    location: location
    storageName: storage.outputs.storageName
  }
}
