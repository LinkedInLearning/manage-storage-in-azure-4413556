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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'umimas${resourceGroup().name}'
  location: location
}

//Storage blob data contributor
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, resourceGroup().id, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  scope: resourceGroup()
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalType: 'ServicePrincipal'
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  properties: {
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
  }
  kind: 'StorageV2'
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
  }

  resource noAccessContainer 'containers' = {
    name: 'attachmentapp'

  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript-upload-blob'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.48.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'TXTCONTENT'
        value: loadTextContent('data/blobs/blob1.txt')
      }
      {
        name: 'JSONCONTENT'
        value: loadTextContent('data/blobs/blob2.json')
      }
      {
        name: 'accountName'
        value: storage.name
      }
    ]
    scriptContent: '''
                      echo "$TXTCONTENT" > blob1.txt
                      echo "$JSONCONTENT" > blob2.json

                      az storage blob upload --account-name $accountName --file blob1.txt --container-name attachmentapp --name wiki/blob1.txt --auth-mode login --overwrite

                      az storage blob upload --account-name $accountName --file blob1.txt --container-name attachmentapp --name wiki/blob2.txt --auth-mode login --overwrite

                      az storage blob upload --account-name $accountName --file blob1.txt --container-name attachmentapp --name wiki/blob3.txt --auth-mode login --overwrite

                      az storage blob upload --account-name $accountName --file blob2.json --container-name attachmentapp --name share/blob1.json --auth-mode login --overwrite

                      az storage blob upload --account-name $accountName --file blob2.json --container-name attachmentapp --name share/blob2.json --auth-mode login --overwrite

                      az storage blob upload --account-name $accountName --file blob2.json --container-name attachmentapp --name share/blob3.json --auth-mode login --overwrite
                  '''
  }
}

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  name: 'default'
  parent: storage
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  name: 'fileshare'
  parent: fileService
  properties: {
    shareQuota: 100 //This is GB
    enabledProtocols: 'SMB'
    signedIdentifiers: [
      {
        accessPolicy: {
          startTime: '2023-03-17T08:49:37.0000000Z'
          expiryTime: '2028-03-17T08:49:37.0000000Z'
          permission: 'rcl' //read, create, list
        }
        id: 'readcreatelist'
      }
    ]
  }
}

output storageEndpoint object = storage.properties.primaryEndpoints
