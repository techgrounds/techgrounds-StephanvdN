param location string = resourceGroup().location

@description('Password Managementserver')
@secure()
param PasswordManagement string = 'P5lyU+e$$4cuPEv_s8ip'

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
    NetworkInterfaceWeb: 'NetworkInterfaceWebServer'
    subnetApp: networkModule.outputs.subnetVnetApp
    publicIPWebServerName: 'PublicIPWebserver'
  }

}

@description('Deploy Managementserver')
module managementseverModule 'managementserver.bicep' = {
  name: 'managementserverDeployment'
  params: {
    location: location
    VmManagementserver: 'Vm-manageserver'
    adminUsername: 'Techgrounds'
    NetworkInterfaceManagement: 'NetworkInterfaceManagementServer'
    adminPassword: PasswordManagement
    publicIPAddressManagementServerName: 'PublicIPManagementServer'
    subnetManagement: networkModule.outputs.subnetVnetManag
  }
}

@description('Deploy Storage')
module storageModule 'storage.bicep' = {
  name: 'StorageDeployment'
  params: {
    location: location
    storageAccountName: 'storagetechgrounds'
    subnetID: networkModule.outputs.subnetVnetManag
  }
}

// output vnetapp string = networkModule.outputs.vnetAppOutput
