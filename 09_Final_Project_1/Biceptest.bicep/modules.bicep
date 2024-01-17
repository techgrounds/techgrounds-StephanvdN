@description('name of the app service plan')
param appServiceAppName string

@description('the type of environment')
@allowed([
  'development'
  'production'
])

param environmentType string = 'production'
param location string = resourceGroup().location


// storageAccount is symbolische naam - 'storageAccount.bicep' is het bicep bstand waaraan gekoppeld
module storageAccount 'storageAccount.bicep' = {
  // hieronder komt de naam van de deployment
  name: 'storageaccountdeployment'
}

module appModule 'app.bicep' = {
  name: 'myApp'
  params: {
    location: location
    AppServiceAppName: appServiceAppName
    environmentType: environmentType
  }
}