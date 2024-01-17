param virtualNetworkApp string
param virtualNetworkManagement string

param location string = resourceGroup().location

module networkModule 'network.bicep' = {
  name: 'networkDeployment'
  params: {
    location: location
    virtualNetworkApp: virtualNetworkApp
    virtualNetworkManagement: virtualNetworkManagement

  }
}
