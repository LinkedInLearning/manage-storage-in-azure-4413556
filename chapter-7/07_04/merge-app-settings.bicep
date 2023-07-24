param currentAppSettings object 
param appSettings object
param configName string

resource siteconfig 'Microsoft.Web/sites/config@2022-03-01' = {
  name: configName
  properties: union(currentAppSettings, appSettings)
}
