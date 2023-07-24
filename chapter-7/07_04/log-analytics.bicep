@description('Log analytics workspace name')
param name string

@description('Workspace location')
param location string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: '0.023'
    }
  }
}

output workspaceId string = logAnalyticsWorkspace.id
