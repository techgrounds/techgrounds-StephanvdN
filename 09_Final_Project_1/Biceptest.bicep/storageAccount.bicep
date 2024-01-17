@description('the region to deploy the resources')
param location string = resourceGroup().location
param staPrefix string = 'learntv'

var staName = '${staPrefix}${uniqueString(resourceGroup().id)}'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: staName
  location: location
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'StorageV2'
}

