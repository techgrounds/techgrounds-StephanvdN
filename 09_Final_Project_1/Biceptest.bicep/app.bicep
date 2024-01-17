param AppServiceAppName string
param environmentType string
param location string = resourceGroup().location

var tags = {
  environmentType: environmentType
}

resource webApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: '${AppServiceAppName}-app'
  location: location
  tags: tags
  properties: {
    serverFarmId: webServerFarm.id
  }
}

resource webServerFarm 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: AppServiceAppName
  tags: tags
  location: location
  kind:'linux'
  sku: {
    name: 'F1'
  }
}


