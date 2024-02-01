param VaultName string
param location string
param VmManagmentserverName string
param VmWebserverName string
param BackupPolicyName string = 'backupPolicy'

var backupFabric = 'Azure'

var protectionContainer = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${VmManagmentserverName}'
var protectedItem = 'vm;iaasvmcontainerv2;${resourceGroup().name};${VmManagmentserverName}'

var protectionContainerWeb = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${VmWebserverName}'
var protectedItemWeb = 'vm;iaasvmcontainerv2;${resourceGroup().name};${VmWebserverName}'

resource VmManagmentserver 'Microsoft.Compute/virtualMachines@2022-03-01' existing = {
  name: VmManagmentserverName
}

resource VmWebserver 'Microsoft.Compute/virtualMachines@2022-03-01' existing = {
  name: VmWebserverName
}

resource recoveryVaultOpdracht 'Microsoft.RecoveryServices/vaults@2022-04-01' = {
  name: VaultName
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }

  properties: {

  }

}

resource recoveryVaultBackupPolicies 'Microsoft.RecoveryServices/vaults/backupPolicies@2022-06-01-preview' = {
  name: BackupPolicyName
  location: location
  parent: recoveryVaultOpdracht
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2024-01-15T22:30:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2024-01-15T22:30:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}

resource vaultName_Onzin 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2022-03-01' = {
  name: '${VaultName}/${backupFabric}/${protectionContainer}/${protectedItem}'
  location: location
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: '${recoveryVaultOpdracht.id}/backupPolicies/DefaultPolicy'
    sourceResourceId: VmManagmentserver.id

  }

}

resource vaultName_Onzin2 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2022-03-01' = {
  name: '${VaultName}/${backupFabric}/${protectionContainerWeb}/${protectedItemWeb}'
  location: location
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: '${recoveryVaultOpdracht.id}/backupPolicies/DefaultPolicy'
    sourceResourceId: VmWebserver.id
  }
}
