targetScope = 'resourceGroup'

param location string = resourceGroup().location

@description('Username Managementserver')
@secure()
param UsernameManagement string = 'Techgrounds'

@description('Password Managementserver')
@secure()
param PasswordManagement string = 'P5lyU+e$$4cuPEv_s8ip'

param VmManagmentserver string = 'VmManagServ'

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
    adminUsername: 'azureuser-techgroundsproject'
    publicIPWebServerName: 'PublicIPWebserver'
    vnetApp: networkModule.outputs.VnetWebName
    networkSecurityGroupAppSubnet: networkModule.outputs.NSGVnetApp

  }

}

@description('Deploy Managementserver')
module managementseverModule 'managementserver.bicep' = {
  name: 'managementserverDeployment'
  params: {
    location: location
    VmManagementserver: VmManagmentserver
    adminUsername: UsernameManagement
    NetworkInterfaceManagement: 'NetworkInterfaceManagementServer'
    adminPassword: PasswordManagement
    publicIPAddressManagementServerName: 'PublicIPManagementServer'
    subnetManagement: networkModule.outputs.subnetVnetManag
  }
}

@description('Deploy Storage')
module storageModule 'storage.bicep' = {
  name: 'storageDeployment'
  params: {
    location: location
    storageAccountName: 'storagetechgrounds'

  }
}

@description('Deploy Keyvault')
module keyvaultModule 'keyvault.bicep' = {
  name: 'keyvaultDeployment'
  params: {
    location: location
    PasswordManagementServer: PasswordManagement
    UsernameManagmentServer: UsernameManagement
  }
}

@description('Deploy Backup')
module backupModule 'backup.bicep' = {
  name: 'backupDeployment'
  params: {
    VaultName: 'recoveryVaultName'
    location: location
    VmManagmentserverName: managementseverModule.outputs.VmManagementserverOutput
  }
}
@description('Deploy SQL')
module sqlModule 'sql.bicep' = {
  name: 'sqlDeployment'
  params: {
    location: location
    vnetApp: networkModule.outputs.VnetWebName
  }
}
