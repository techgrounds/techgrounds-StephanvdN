param virtualNetworks_app_prd_vnet_name string = 'app-prd-vnet'
param networkSecurityGroups_application_subnet_nsg_externalid string = '/subscriptions/8250817b-e1f5-4ed3-a506-2453da6268b6/resourceGroups/Techgrounds-project/providers/Microsoft.Network/networkSecurityGroups/application-subnet-nsg'
param virtualNetworks_managment_prd_vnet_externalid string = '/subscriptions/8250817b-e1f5-4ed3-a506-2453da6268b6/resourceGroups/Techgrounds-project/providers/Microsoft.Network/virtualNetworks/managment-prd-vnet'

resource virtualNetworks_app_prd_vnet_name_resource 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: virtualNetworks_app_prd_vnet_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.20.0/24'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: 'application-subnet'
        id: virtualNetworks_app_prd_vnet_name_application_subnet.id
        properties: {
          addressPrefixes: [
            '10.20.20.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_application_subnet_nsg_externalid
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: true
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'managementServer-webServer-peering'
        id: virtualNetworks_app_prd_vnet_name_managementServer_webServer_peering.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_managment_prd_vnet_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.10.10.0/24'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.10.10.0/24'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_app_prd_vnet_name_application_subnet 'Microsoft.Network/virtualNetworks/subnets@2023-06-01' = {
  name: '${virtualNetworks_app_prd_vnet_name}/application-subnet'
  properties: {
    addressPrefixes: [
      '10.20.20.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_application_subnet_nsg_externalid
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: true
  }
  dependsOn: [
    virtualNetworks_app_prd_vnet_name_resource
  ]
}

resource virtualNetworks_app_prd_vnet_name_managementServer_webServer_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-06-01' = {
  name: '${virtualNetworks_app_prd_vnet_name}/managementServer-webServer-peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_managment_prd_vnet_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.10.10.0/24'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.10.10.0/24'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_app_prd_vnet_name_resource
  ]
}