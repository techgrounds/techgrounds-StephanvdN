param location string
param storageAccountName string
param subnetID string

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
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    /*
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [ {
          id: subnetID
          action: 'Allow'
          state: 'Succeeded'
        }
      ]

      defaultAction: 'Deny'
    }
    */
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: true
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
