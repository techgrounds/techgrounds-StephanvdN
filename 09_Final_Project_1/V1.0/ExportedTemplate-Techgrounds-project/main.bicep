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
    Vnet1Peering: 'peering1'
    Vnet2Peering: 'peering2'

  }
}

@description('Deploy Webserver')
module webserverModule 'webserver.bicep' = {
  name: 'webserverDeployment'
  params: {
    location: location
    VmWebserver: 'Vm-webserver'
    adminUsername: 'azureuser-techgroundsproject'
    NetworkInterface: 'NetworkInterface'
  }

}

// output vnetapp string = networkModule.outputs.vnetAppOutput
