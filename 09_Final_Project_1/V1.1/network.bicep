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
  subnetPrefixes: '10.20.20.64/26'

}

var vnetmanagementconfig = {
  addresPrefixes: '10.10.10.0/24'
  subnetName: 'ManagementSubnet'
  subnetPrefixes: '10.10.10.0/24'
}

var SubnetGatewayConfig = {
  addresPrefixes: '10.20.20.0/24'
  subnetName: 'GWSubnet'
  subnetPrefixes: '10.20.20.128/26'
}

var NSGAppSSH = {
  name: 'SSHInbound'
  properties: {
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    priority: 100
  }
}

var NSGAppHTTP = {
  name: 'HTTPInbound'
  properties: {
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    priority: 110

  }
}

var NSGManagRDP = {
  name: 'RDPInbound'
  properties: {
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    priority: 100

  }
}

var NSGManagSSH = {
  name: 'SSHInbound'
  properties: {
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    priority: 110

  }
}

resource networkSecurityGroupAppSubnet 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsgAppSubnet
  location: location
  properties: {
    securityRules: [
      {
        name: NSGAppSSH.name
        properties: {
          direction: NSGAppSSH.properties.direction
          access: NSGAppSSH.properties.access
          protocol: NSGAppSSH.properties.protocol
          sourcePortRange: NSGAppSSH.properties.sourcePortRange
          destinationPortRange: NSGAppSSH.properties.destinationPortRange
          sourceAddressPrefix: NSGAppSSH.properties.sourceAddressPrefix
          destinationAddressPrefix: NSGAppSSH.properties.destinationAddressPrefix
          priority: NSGAppSSH.properties.priority

        }
      }
      {
        name: NSGAppHTTP.name
        properties: {
          direction: NSGAppHTTP.properties.direction
          access: NSGAppHTTP.properties.access
          protocol: NSGAppHTTP.properties.protocol
          sourcePortRange: NSGAppHTTP.properties.sourcePortRange
          destinationPortRange: NSGAppHTTP.properties.destinationAddressPrefix
          sourceAddressPrefix: NSGAppHTTP.properties.sourceAddressPrefix
          destinationAddressPrefix: NSGAppHTTP.properties.destinationAddressPrefix
          priority: NSGAppHTTP.properties.priority

        }

      }
    ]
  }
}

resource networkSecurityGroupManagementSubnet 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsgManagementSubnet
  location: location
  properties: {
    securityRules: [
      {
        name: NSGManagRDP.name
        properties: {
          direction: NSGManagRDP.properties.direction
          access: NSGManagRDP.properties.access
          protocol: NSGManagRDP.properties.protocol
          sourcePortRange: NSGManagRDP.properties.sourcePortRange
          destinationPortRange: NSGManagRDP.properties.destinationPortRange
          sourceAddressPrefix: NSGManagRDP.properties.sourceAddressPrefix
          destinationAddressPrefix: NSGManagRDP.properties.destinationAddressPrefix
          priority: NSGManagRDP.properties.priority

        }

      }
      {
        name: NSGManagSSH.name
        properties: {
          direction: NSGManagSSH.properties.direction
          access: NSGManagSSH.properties.access
          protocol: NSGManagSSH.properties.protocol
          sourcePortRange: NSGManagSSH.properties.sourcePortRange
          destinationPortRange: NSGManagSSH.properties.destinationPortRange
          sourceAddressPrefix: NSGManagSSH.properties.sourceAddressPrefix
          destinationAddressPrefix: NSGManagSSH.properties.destinationAddressPrefix
          priority: NSGManagSSH.properties.priority

        }
      }
    ]
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
      {
        name: SubnetGatewayConfig.subnetName
        properties: {
          addressPrefix: SubnetGatewayConfig.subnetPrefixes
          // networkSecurityGroup: {
          //   id: networkSecurityGroupAppSubnet.id
          // }
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
output NSGVnetApp string = networkSecurityGroupAppSubnet.name
// output GatewaySubnet string = vnetApp.properties.subnets[1].id
output VnetWebName string = vnetApp.name
