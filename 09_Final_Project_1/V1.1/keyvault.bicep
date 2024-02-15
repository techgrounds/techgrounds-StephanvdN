param location string = resourceGroup().location
param tenantid string = 'de60b253-74bd-4365-b598-b9e55a2b208d'
param objectid string = '09fad378-c556-471c-aece-7f5142dea036'

@description('Contains the username of the managementserver')
param UsernameManagmentServer string

@description('Contains the password of the managementserver')
param PasswordManagementServer string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'KeyVault1${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '81.19.209.53'
        }
      ]
      virtualNetworkRules: [

      ]
    }
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantid
    accessPolicies: [
      {
        permissions: {
          secrets: [
            'all'
          ]
        }
        tenantId: tenantid
        objectId: objectid
      }
      {
        permissions: {
          certificates: [
            'all'

          ]
        }
        tenantId: tenantid
        objectId: objectid
      }
      {
        permissions: {
          keys: [
            'all'
          ]
        }
        tenantId: tenantid
        objectId: objectid
      }
      {
        permissions: {
          storage: [
            'all'
          ]
        }
        tenantId: tenantid
        objectId: objectid
      }
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: true
    enableSoftDelete: true
    vaultUri: 'https://keyvaultsteph.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
    softDeleteRetentionInDays: 7

  }
}

resource PasswordManagementServerResource 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: 'PasswordManagementServer'
  properties: {
    value: PasswordManagementServer
  }
}

resource UsernameManagementServer 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: 'UsernameManagementServer'
  properties: {
    value: UsernameManagmentServer
  }
}
