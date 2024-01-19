param location string = resourceGroup().location

@description('Deploy Network')
module networkModule 'network.bicep' = {
  name: 'networkDeployment'
  params: {
    location: location
    virtualNetworkApp: 'appvNet'
    virtualNetworkManagement: 'managementVnet'
    nsgAppSubnet: 'NsgApp'
    nsgManagementSubnet: 'NsgManagement'

  }
}

// output vnetapp string = networkModule.outputs.vnetAppOutput
