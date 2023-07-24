@description('The name of the functionapp the settings must be applied to')
param functionAppName string

@description('The name of the storage assigned to the function app')
param storageAccountName string

@description('The name of the managed identity')
param systemManagedId string

resource functionAppSlotConfigNames 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${functionAppName}/slotConfigNames'
  properties: {
    appSettingNames: [
      'CustomerApiKey'
    ]
  }
}

resource assignedStorage 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

// The union is used to merge the current app settings if a live WebApp is already deployed with
// The new app settings if they are different, this is to keep WEBSITE_RUN_FROM_PACKAGE setting for
// deployed code, see - https://stackoverflow.com/a/72946083
module appSettings 'merge-app-settings.bicep' = {
  name: 'merged-site-config'
  params: {
    configName: '${functionAppName}/appsettings'
    #disable-next-line parameter-types-should-be-consistent
    currentAppSettings: list(resourceId('Microsoft.Web/sites/config', functionAppName, 'appsettings'), '2020-12-01').properties
    appSettings: {
      AzureWebJobsFeatureFlags: 'EnableWorkerIndexing'
      AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${assignedStorage.name};AccountKey=${assignedStorage.listKeys().keys[0].value}'
      Storage: 'DefaultEndpointsProtocol=https;AccountName=${assignedStorage.name};AccountKey=${assignedStorage.listKeys().keys[0].value}'
      WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${assignedStorage.name};AccountKey=${assignedStorage.listKeys().keys[0].value}'
      WEBSITE_CONTENTSHARE: toLower(functionAppName)
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'python'
      USER_MANAGED_CLIENT_ID: systemManagedId
    }
  }
}
