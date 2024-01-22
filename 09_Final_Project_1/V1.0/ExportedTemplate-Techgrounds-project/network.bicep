param location string = resourceGroup().location
param virtualNetworkApp string
param virtualNetworkManagement string
param nsgAppSubnet string
param nsgManagementSubnet string
param Vnet1Peering string
param Vnet2Peering string

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
          networkSecurityGroup: {
            id: networkSecurityGroupAppSubnet.id
          }

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
          networkSecurityGroup: {
            id: networkSecurityGroupManagementSubnet.id }

        }

      }
    ]

  }
}

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  parent: vnetApp
  name: Vnet1Peering
  properties: {
    remoteVirtualNetwork: {
      id: vnetManagement.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource VnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  parent: vnetManagement
  name: Vnet2Peering
  properties: {
    remoteVirtualNetwork: {
      id: vnetApp.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false

  }
}

output subnetVnetApp string = vnetApp.properties.subnets[0].id
output subnetVnetManag string = vnetManagement.properties.subnets[0].id
