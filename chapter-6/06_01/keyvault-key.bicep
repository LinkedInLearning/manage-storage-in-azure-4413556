@description('Static type suffix for the storage resources')
@minLength(3)
@maxLength(9)
param resourceSuffix string

@description('The location of the resources')
param location string = resourceGroup().location

@description('The storage name to retrive the managed identity')
param storageName string

@description('The SKU of the vault to be created.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('The JsonWebKeyType of the key to be created.')
@allowed([
  'EC'
  'EC-HSM'
  'RSA'
  'RSA-HSM'
])
param keyType string = 'RSA'

@description('The permitted JSON web key operations of the key to be created.')
param keyOps array = []

@description('The size in bits of the key to be created.')
param keySize int = 2048

@description('The JsonWebKeyCurveName of the key to be created.')
@allowed([
  ''
  'P-256'
  'P-256K'
  'P-384'
  'P-521'
])
param curveName string = ''

var vaultName = 'kvmsa${resourceSuffix}${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageName
}

resource vault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: vaultName
  location: location
  properties: {
    accessPolicies:[]
    enableRbacAuthorization: true
    enableSoftDelete: false
    enablePurgeProtection: null
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    tenantId: subscription().tenantId
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

//Three keys for the demo
resource key 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  parent: vault
  name: 'storageencryptionkey'
  properties: {
    kty: keyType
    keyOps: keyOps
    keySize: keySize
    curveName: curveName
  }
}

resource custkey1 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  parent: vault
  name: 'customer1'
  properties: {
    kty: keyType
    keyOps: keyOps
    keySize: keySize
    curveName: curveName
  }
}

resource custkey2  'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  parent: vault
  name: 'customer2'
  properties: {
    kty: keyType
    keyOps: keyOps
    keySize: keySize
    curveName: curveName
  }
}

//Key vault crypto user - storage system identity
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storage.name, resourceGroup().id, '12338af0-0e69-4776-bea7-57ae8d297424')
  scope: resourceGroup()
  properties: {
    principalId: storage.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424')
    principalType: 'ServicePrincipal'
  }
}
