param location string = resourceGroup().location
param virtualNetworkApp string
param virtualNetworkManagement string
param nsgAppSubnet string
param nsgManagementSubnet string

var vnetappconfig = {
  addressPrefixes: '10.20.20.0/24'
  subnetName: 'appSubnet'
  subnetPrefixes: '10.20.20.0/24'

}

var vnetmanagementconfig = {
  addresPrefixes: '10.10.10.0/24'
  subnetName: 'ManagementSubnet'
  subnetPrefixes: '10.10.10.0/24'
}

resource networkSecurityGroupAppSubnet 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsgAppSubnet
  location: location
  properties: {
    securityRules: []
  }
}

resource networkSecurityGroupManagementSubnet 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsgManagementSubnet
  location: location
  properties: {
    securityRules: []
  }
}

resource vnetApp 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkApp
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetappconfig.addressPrefixes
      ]
    }
    subnets: [
      {
        name: vnetappconfig.subnetName
        properties: {
          addressPrefix: vnetappconfig.subnetPrefixes
        }
      }
    ]
  }

}

resource vnetManagement 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkManagement
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetmanagementconfig.addresPrefixes
      ]
    }
    subnets: [
      {
        name: vnetmanagementconfig.subnetName
        properties: {
          addressPrefix: vnetmanagementconfig.subnetPrefixes
        }
      }
    ]
  }
}
