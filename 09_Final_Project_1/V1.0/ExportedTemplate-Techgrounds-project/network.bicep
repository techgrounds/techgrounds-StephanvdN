param location string = resourceGroup().location
param virtualNetworkApp string
param virtualNetworkManagement string
param nsgAppSubnet string
param nsgManagementSubnet string
param Vnet1PeeringAppManag string
param Vnet2PeeringManagApp string

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

var vnetPeeringManagApp = {
  remoteAddressSpaceAddressPrefixes: '10.10.10.0/24'
  remoteVirtualNetworkAddressSpaceAddressPrefixes: '10.10.10.0/24'
}

var vnetPeeringAppManag = {
  remoteAddressSpaceAddressPrefixes: '10.20.20.0/24'
  remoteVirtualNetworkAddressSpaceAddressPrefixes: '10.20.20.0/24'

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

resource VnetPeeringAppManag 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: Vnet1PeeringAppManag
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: vnetManagement.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        vnetPeeringManagApp.remoteAddressSpaceAddressPrefixes
        // '10.10.10.0/24'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        vnetPeeringManagApp.remoteVirtualNetworkAddressSpaceAddressPrefixes
        // '10.10.10.0/24'
      ]
    }

  }
  dependsOn: [
    vnetApp
  ]
}

resource VnetPeeringManagApp 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: Vnet2PeeringManagApp
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: vnetApp.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        vnetPeeringAppManag.remoteAddressSpaceAddressPrefixes

        // '10.20.20.0/24'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [

        vnetPeeringAppManag.remoteVirtualNetworkAddressSpaceAddressPrefixes
        // '10.20.20.0/24'
      ]
    }
  }
  dependsOn: [
    vnetManagement
  ]
}

// output vnetAppOutput string = virtualNetworkApp
