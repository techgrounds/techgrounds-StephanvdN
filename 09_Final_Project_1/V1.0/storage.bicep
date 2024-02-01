param location string
param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {

    dnsEndpointType: 'Standard'
    allowedCopyScope: 'PrivateLink'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true

    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {

      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }

      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource blobStorageAccount 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: storageAccount
  name: 'default'
  properties: {

  }
}

resource blobStorageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: blobStorageAccount
  name: 'default'
  properties: {}

}
