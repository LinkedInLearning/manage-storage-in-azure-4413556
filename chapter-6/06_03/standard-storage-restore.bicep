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

var uniqueStorageName = 'sar${resourceSuffix}${uniqueString(resourceGroup().id)}'

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
    deleteRetentionPolicy: {
      days: 14
      enabled: true
    }
    isVersioningEnabled: true
    changeFeed: {
    enabled: true
    retentionInDays: 14
    }
   restorePolicy: {
    enabled: true
    days: 7
   }
  }

  resource containerrestore 'containers' = {
    name: 'containerrestore'
  }
  resource containerrestore2 'containers' = {
    name: 'containerresdel1'
  }
  resource containerrestore3 'containers' = {
    name: 'containeredit1'
  }
  resource containerrestore4 'containers' = {
    name: 'containerresdel2'
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

                        az storage blob upload --file blob1.txt --container-name containerrestore --name blob1.txt

                        az storage blob upload --file blob2.json --container-name containerrestore --name blob1.json

                        az storage blob upload --file blob1.txt --container-name containerresdel1 --name blob2.txt

                        az storage blob upload --file blob2.json --container-name containerresdel1 --name blob2.json

                        az storage blob upload --file blob1.txt --container-name containeredit1 --name blob3.txt

                        az storage blob upload --file blob2.json --container-name containeredit1 --name blob3.json

                        az storage blob upload --file blob1.txt --container-name containerresdel2 --name blob4.txt

                        az storage blob upload --file blob2.json --container-name containerresdel2 --name blob4.json

                  '''
  }
}

output storageEndpoint object = storage.properties.primaryEndpoints
