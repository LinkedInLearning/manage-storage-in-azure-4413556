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

@description('The object ID of the logged in user')
param identityPrincipalId string

var uniqueStorageName = 'sa${resourceSuffix}${uniqueString(resourceGroup().id)}'

var functionAppName = 'fa${resourceSuffix}${uniqueString(resourceGroup().id)}'

var logAnalyticsName = 'law${resourceSuffix}${uniqueString(resourceGroup().id)}'

//Storage blob data contributor for logged in user 
resource roleAssignmentLogin 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(identityPrincipalId, resourceGroup().id, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  scope: resourceGroup()
  properties: {
    principalId: identityPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalType: 'User'
  }
}

module logAnalytics 'log-analytics.bicep' = {
  name: 'loganalyticsworkspace'
  params: {
    location: location
    name: logAnalyticsName
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
    allowSharedKeyAccess: true
  }
  kind: 'StorageV2'
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'sadiagsetting'
  scope: storage
  properties: {
    workspaceId: logAnalytics.outputs.workspaceId
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storage
  properties: {
    isVersioningEnabled: false
  }

  resource loadcontainer1 'containers' = {
    name: 'loadcontainer1'

  }
  resource loadcontainer2 'containers' = {
    name: 'loadcontainer2'

  }
}

resource blobSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'blobdiagsetting'
  scope: blobService
  properties: {
    workspaceId: logAnalytics.outputs.workspaceId
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}


//Create an app service plan for the function app
module plan 'app-service-plan.bicep' = {
  name: 'fapyplan'
  params: {
    location: location
    name: 'asp-${functionAppName}'
    os: 'Linux'
  }
}

//Create the function app without settings
module functionApp 'azure-function.bicep' = {
  name: 'fapyitops'
  params: {
    location: location
    name: functionAppName
    planId: plan.outputs.planId
  }
}

//Create a storage account for the function app
module fastorage 'azure-function-storage.bicep' = {
  name: 'fapystorage'
  params: {
    location: location
  }
}

//Create a storage account for running the dev version of the funcitonapp locally for testing
module fastorageDev 'azure-function-storage.bicep' = {
  name: 'fapystoragedev'
  params: {
    location: location
    storagePrefix: 'sapyfad'
  }
}

//Apply settings to the function app
module functionAppSettings 'azure-function-settings.bicep' = {
  name: 'fapyitopssettings'
  params: {
    functionAppName: functionApp.outputs.prodFunctionAppName
    storageAccountName: fastorage.outputs.stgName
    systemManagedId: functionApp.outputs.managedIdentityprincipalId
  }
  dependsOn: [
    fastorage
  ]
}

//Storage blob data contributor system managed identity on function app
resource roleAssignmentFunc 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(functionApp.name, resourceGroup().id, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  scope: resourceGroup()
  properties: {
    principalId: functionApp.outputs.managedIdentityprincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    functionApp
  ]
}

output storageEndpoint object = storage.properties.primaryEndpoints
