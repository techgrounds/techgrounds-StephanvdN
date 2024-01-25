param location string = resourceGroup().location
param tenantid string = 'de60b253-74bd-4365-b598-b9e55a2b208d'
param objectid string = '09fad378-c556-471c-aece-7f5142dea036'
param keyvaultSSH string = 'test'

param SSHWebserverPath string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9tgl27jmiprWvxTKmatb846TAnFilwJM+Q3C3ysidnabj4qRYYtx56zHUQbxUl9WVbfYa8MjJ5lqwgNBFPIrHPIhUauRR7f7g0rHVx39k/XiM0De9B5Ur4f9YIb0W1l1r4dWXjCpfzB/9gNxkTQ3C+G+y4L/aJ+TU/2xUtrt0s+29DgHQ15rJJ7iUA7repe4/OTNh1b/Vgp7HWwtTmH/EuqwOpxUVkMZPM0Jp20N3aVPlVP2czT22h/XT1dQtpHpfrRwrAM8ZzLf8yNCOIr2J8K6gv8ysJzIYfNALJcljaCjBOFmVTziuKW1KA/GspOslg7kPBxwLb+kmNUZNs+nQgO6wbcbJYvdZqXJOEW5192s0+WBQ84x7kum4cboJ6aWvjcfOCi+VWTOAaLXABTSPE41CvMDUp5OHCq+YU7HXRIubZm5yySrZr8T0TBWfDMFOadaUkyDWhD/2vjjVXvkcPUXrmbhzg4q2ov8NqSaUZBVmj2yQT9aa09qxs9mOjHE= generated-by-azure'

@description('Contains the username of the managementserver')
param ManagmentServerPWSecret string

@description('Contains the password of the managementserver')
param PasswordManagement string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'KeyVaultDeSteph'
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
  }
}

resource PasswordManagementServer 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: ManagmentServerPWSecret
  properties: {
    value: PasswordManagement
  }
}

resource SSHKeyWebserver 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: keyvaultSSH
  properties: {
    value: SSHWebserverPath

  }
}

resource Keyvoorbeeld 'Microsoft.KeyVault/vaults/keys@2022-07-01'
