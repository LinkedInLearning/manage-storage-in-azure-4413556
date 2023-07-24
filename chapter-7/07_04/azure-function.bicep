@description('App Service Plan name')
param name string

@description('App Service Plan location')
param location string

@description('App Service Plan Id')
param planId string

resource functionAppResource 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: planId
    containerSize: 1536
    siteConfig: {
      linuxFxVersion: 'Python|3.9'
    }
  }
}

output prodFunctionAppName string = functionAppResource.name
output managedIdentityprincipalId string = functionAppResource.identity.principalId
