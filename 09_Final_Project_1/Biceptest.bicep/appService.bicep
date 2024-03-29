param location string
param appServiceAppName string

@allowed([
  'nonprod'
  'prod'
])
param enviromentType string

var appServicePlanName = 'toy-product-launch-plan'
var appServicePlanSkuName = (enviromentType == 'prod') ? 'P2v3' : 'F1'

resource AppServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: AppServicePlan.id
    httpsOnly: true
  }

}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
