param location string = resourceGroup().location
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param enviromentType string

var storageAccountSkuName = (enviromentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module app 'appService.bicep' = {
  name: 'app'
  params: {
    appServiceAppName: appServiceAppName
    enviromentType: enviromentType
    location: location
  }
}

output AppServiceAppHostName string = app.outputs.appServiceAppHostName
