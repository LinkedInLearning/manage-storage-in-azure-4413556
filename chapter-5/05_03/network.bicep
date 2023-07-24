

@description('Location for all resources.')
param location string

@description('Suffix for resources.')
param suffix string

var addressPrefix = '10.0.0.0/16'
var subnetName = 'snet-${suffix}'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'vnet-${suffix}'
var networkSecurityGroupName = 'nsg-${suffix}'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP-Allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

output subnetId string = virtualNetwork.properties.subnets[0].id
output subnetName string = virtualNetwork.properties.subnets[0].name
output vnetId string = virtualNetwork.id
output vnetName string = virtualNetwork.name
