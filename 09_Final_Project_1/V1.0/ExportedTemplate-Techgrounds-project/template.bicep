param virtualMachines_web_server_name string = 'web-server'
param virtualNetworks_app_prd_vnet_name string = 'app-prd-vnet'
param vaults_keyVault_techgr_project_name string = 'keyVault-techgr-project'
param publicIPAddresses_web_server_ip_name string = 'web-server-ip'
param virtualMachines_management_server_name string = 'management-server'
param networkInterfaces_web_server106_z2_name string = 'web-server106_z2'
param virtualNetworks_managment_prd_vnet_name string = 'managment-prd-vnet'
param sshPublicKeys_techgroundsproject_key_name string = 'techgroundsproject-key'
param publicIPAddresses_management_server_ip_name string = 'management-server-ip'
param storageAccounts_projectstoragetechground_name string = 'projectstoragetechground'
param networkInterfaces_management_server320_z1_name string = 'management-server320_z1'
param privateEndpoints_project_recovery_endpoint_name string = 'project-recovery-endpoint'
param vaults_techgrounds_recovery_vault_name string = 'techgrounds-recovery-vault'
param networkSecurityGroups_management_subnet_nsg_name string = 'management-subnet-nsg'
param networkSecurityGroups_application_subnet_nsg_name string = 'application-subnet-nsg'

// PUBLIC KEY
resource sshPublicKeys_techgroundsproject_key_name_resource 'Microsoft.Compute/sshPublicKeys@2023-03-01' = {
  name: sshPublicKeys_techgroundsproject_key_name
  location: 'westeurope'
  properties: {
    publicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9tgl27jmiprWvxTKmatb846TAnFilwJM+Q3C3ysidnabj4qRYYtx56zHUQbxUl9WVbfYa8MjJ5lqwgNBFPIrHPIhUauRR7f7g0rHVx39k/XiM0De9B5Ur4f9YIb0W1l1r4dWXjCpfzB/9gNxkTQ3C+G+y4L/aJ+TU/2xUtrt0s+29DgHQ15rJJ7iUA7repe4/OTNh1b/Vgp7HWwtTmH/EuqwOpxUVkMZPM0Jp20N3aVPlVP2czT22h/XT1dQtpHpfrRwrAM8ZzLf8yNCOIr2J8K6gv8ysJzIYfNALJcljaCjBOFmVTziuKW1KA/GspOslg7kPBxwLb+kmNUZNs+nQgO6wbcbJYvdZqXJOEW5192s0+WBQ84x7kum4cboJ6aWvjcfOCi+VWTOAaLXABTSPE41CvMDUp5OHCq+YU7HXRIubZm5yySrZr8T0TBWfDMFOadaUkyDWhD/2vjjVXvkcPUXrmbhzg4q2ov8NqSaUZBVmj2yQT9aa09qxs9mOjHE= generated-by-azure'
  }
}

// NETWORK SECURITY GROUPS
resource networkSecurityGroups_application_subnet_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2023-06-01' = {
  name: networkSecurityGroups_application_subnet_nsg_name
  location: 'westeurope'
  properties: {
    securityRules: []
  }
}

resource networkSecurityGroups_management_subnet_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2023-06-01' = {
  name: networkSecurityGroups_management_subnet_nsg_name
  location: 'westeurope'
  properties: {
    securityRules: []
  }
}

resource publicIPAddresses_management_server_ip_name_resource 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: publicIPAddresses_management_server_ip_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '4.231.1.153'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_web_server_ip_name_resource 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: publicIPAddresses_web_server_ip_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '2'
  ]
  properties: {
    ipAddress: '20.56.91.67'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource vaults_techgrounds_recovery_vault_name_resource 'Microsoft.RecoveryServices/vaults@2023-06-01' = {
  name: vaults_techgrounds_recovery_vault_name
  location: 'westeurope'
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    securitySettings: {
      immutabilitySettings: {
        state: 'Disabled'
      }
      softDeleteSettings: {
        softDeleteRetentionPeriodInDays: 0
        softDeleteState: 'Enabled'
      }
      multiUserAuthorization: 'Disabled'
    }
    redundancySettings: {}
    publicNetworkAccess: 'Disabled'
    restoreSettings: {
      crossSubscriptionRestoreSettings: {
        crossSubscriptionRestoreState: 'Enabled'
      }
    }
  }
}

resource virtualMachines_management_server_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_management_server_name
  location: 'westeurope'
  zones: [
    '1'
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition-hotpatch'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_management_server_name}_OsDisk_1_fc81cda70e4944079d4a30fce1f48de9'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_management_server_name}_OsDisk_1_fc81cda70e4944079d4a30fce1f48de9')
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: 'management-serv'
      adminUsername: 'Techgrounds'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
            bypassPlatformSafetyChecksOnUserSchedule: false
          }
          assessmentMode: 'ImageDefault'
          enableHotpatching: true
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_management_server320_z1_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_web_server_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_web_server_name
  location: 'westeurope'
  zones: [
    '2'
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_web_server_name}_OsDisk_1_e7213bbab0d047bf843364ab2902329e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_web_server_name}_OsDisk_1_e7213bbab0d047bf843364ab2902329e')
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_web_server_name
      adminUsername: 'azureuser-techgroundsproject'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/azureuser-techgroundsproject/.ssh/authorized_keys'
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9tgl27jmiprWvxTKmatb846TAnFilwJM+Q3C3ysidnabj4qRYYtx56zHUQbxUl9WVbfYa8MjJ5lqwgNBFPIrHPIhUauRR7f7g0rHVx39k/XiM0De9B5Ur4f9YIb0W1l1r4dWXjCpfzB/9gNxkTQ3C+G+y4L/aJ+TU/2xUtrt0s+29DgHQ15rJJ7iUA7repe4/OTNh1b/Vgp7HWwtTmH/EuqwOpxUVkMZPM0Jp20N3aVPlVP2czT22h/XT1dQtpHpfrRwrAM8ZzLf8yNCOIr2J8K6gv8ysJzIYfNALJcljaCjBOFmVTziuKW1KA/GspOslg7kPBxwLb+kmNUZNs+nQgO6wbcbJYvdZqXJOEW5192s0+WBQ84x7kum4cboJ6aWvjcfOCi+VWTOAaLXABTSPE41CvMDUp5OHCq+YU7HXRIubZm5yySrZr8T0TBWfDMFOadaUkyDWhD/2vjjVXvkcPUXrmbhzg4q2ov8NqSaUZBVmj2yQT9aa09qxs9mOjHE= generated-by-azure'
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_web_server106_z2_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource vaults_keyVault_techgr_project_name_resource 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaults_keyVault_techgr_project_name
  location: 'westeurope'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: 'de60b253-74bd-4365-b598-b9e55a2b208d'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: [
        {
          id: virtualNetworks_managment_prd_vnet_name_management_subnet.id
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
    accessPolicies: []
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
    vaultUri: 'https://keyvault-techgr-project.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}

resource vaults_techgrounds_recovery_vault_name_DefaultPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-06-01' = {
  parent: vaults_techgrounds_recovery_vault_name_resource
  name: 'DefaultPolicy'
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

resource vaults_techgrounds_recovery_vault_name_EnhancedPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-06-01' = {
  parent: vaults_techgrounds_recovery_vault_name_resource
  name: 'EnhancedPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Hourly'
      hourlySchedule: {
        interval: 4
        scheduleWindowStartTime: '2024-01-15T08:00:00Z'
        scheduleWindowDuration: 12
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2024-01-15T08:00:00Z'
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

resource vaults_techgrounds_recovery_vault_name_HourlyLogBackup 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-06-01' = {
  parent: vaults_techgrounds_recovery_vault_name_resource
  name: 'HourlyLogBackup'
  properties: {
    backupManagementType: 'AzureWorkload'
    workLoadType: 'SQLDataBase'
    settings: {
      timeZone: 'UTC'
      issqlcompression: false
      isCompression: false
    }
    subProtectionPolicy: [
      {
        policyType: 'Full'
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
      }
      {
        policyType: 'Log'
        schedulePolicy: {
          schedulePolicyType: 'LogSchedulePolicy'
          scheduleFrequencyInMins: 60
        }
        retentionPolicy: {
          retentionPolicyType: 'SimpleRetentionPolicy'
          retentionDuration: {
            count: 30
            durationType: 'Days'
          }
        }
      }
    ]
    protectedItemsCount: 0
  }
}

resource vaults_techgrounds_recovery_vault_name_defaultAlertSetting 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2023-06-01' = {
  parent: vaults_techgrounds_recovery_vault_name_resource
  name: 'defaultAlertSetting'
  properties: {
    sendToOwners: 'DoNotSend'
    customEmailAddresses: []
  }
}

resource vaults_techgrounds_recovery_vault_name_default 'Microsoft.RecoveryServices/vaults/replicationVaultSettings@2023-06-01' = {
  parent: vaults_techgrounds_recovery_vault_name_resource
  name: 'default'
  properties: {}
}

resource storageAccounts_projectstoragetechground_name_resource 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccounts_projectstoragetechground_name
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
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
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: virtualNetworks_managment_prd_vnet_name_management_subnet.id
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
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

resource storageAccounts_projectstoragetechground_name_default 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccounts_projectstoragetechground_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_projectstoragetechground_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' = {
  parent: storageAccounts_projectstoragetechground_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_projectstoragetechground_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-01-01' = {
  parent: storageAccounts_projectstoragetechground_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_projectstoragetechground_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-01-01' = {
  parent: storageAccounts_projectstoragetechground_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource networkInterfaces_management_server320_z1_name_resource 'Microsoft.Network/networkInterfaces@2023-06-01' = {
  name: networkInterfaces_management_server320_z1_name
  location: 'westeurope'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_management_server320_z1_name_resource.id}/ipConfigurations/ipconfig1'
        etag: 'W/"3a02e00d-9815-4bb4-afc3-9a54c3ba0b57"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.10.10.6'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_management_server_ip_name_resource.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: virtualNetworks_managment_prd_vnet_name_management_subnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_web_server106_z2_name_resource 'Microsoft.Network/networkInterfaces@2023-06-01' = {
  name: networkInterfaces_web_server106_z2_name
  location: 'westeurope'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_web_server106_z2_name_resource.id}/ipConfigurations/ipconfig1'
        etag: 'W/"4f965a62-2088-43bd-ab60-ccf019a6b8e7"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.20.20.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_web_server_ip_name_resource.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: virtualNetworks_app_prd_vnet_name_application_subnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource privateEndpoints_project_recovery_endpoint_name_resource 'Microsoft.Network/privateEndpoints@2023-06-01' = {
  name: privateEndpoints_project_recovery_endpoint_name
  location: 'westeurope'
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoints_project_recovery_endpoint_name}_319a112c-a7bf-4d6a-bc44-bfc47e89d097'
        id: '${privateEndpoints_project_recovery_endpoint_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_project_recovery_endpoint_name}_319a112c-a7bf-4d6a-bc44-bfc47e89d097'
        properties: {
          privateLinkServiceId: vaults_techgrounds_recovery_vault_name_resource.id
          groupIds: [
            'AzureBackup'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'None'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_managment_prd_vnet_name_management_subnet.id
    }
    ipConfigurations: []
    customDnsConfigs: [
      {
        fqdn: '1132794570626989392-ab-pod01-rec2.privatelink.we.backup.windowsazure.com'
        ipAddresses: [
          '10.10.10.4'
        ]
      }
      {
        fqdn: '1132794570626989392-ab-pod01-id1.privatelink.we.backup.windowsazure.com'
        ipAddresses: [
          '10.10.10.5'
        ]
      }
    ]
  }
}

resource virtualNetworks_app_prd_vnet_name_resource 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: virtualNetworks_app_prd_vnet_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.20.0/24'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: 'application-subnet'
        id: virtualNetworks_app_prd_vnet_name_application_subnet.id
        properties: {
          addressPrefixes: [
            '10.20.20.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_application_subnet_nsg_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: true
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'managementServer-webServer-peering'
        id: virtualNetworks_app_prd_vnet_name_managementServer_webServer_peering.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_managment_prd_vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.10.10.0/24'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.10.10.0/24'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_managment_prd_vnet_name_resource 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: virtualNetworks_managment_prd_vnet_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.10.0/24'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: 'management-subnet'
        id: virtualNetworks_managment_prd_vnet_name_management_subnet.id
        properties: {
          addressPrefixes: [
            '10.10.10.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_management_subnet_nsg_name_resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
              locations: [
                '*'
              ]
            }
            {
              service: 'Microsoft.Storage'
              locations: [
                'westeurope'
                'northeurope'
              ]
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: true
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'managementServer-webServer-peering'
        id: virtualNetworks_managment_prd_vnet_name_managementServer_webServer_peering.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_app_prd_vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.20.20.0/24'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.20.20.0/24'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_app_prd_vnet_name_application_subnet 'Microsoft.Network/virtualNetworks/subnets@2023-06-01' = {
  name: '${virtualNetworks_app_prd_vnet_name}/application-subnet'
  properties: {
    addressPrefixes: [
      '10.20.20.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_application_subnet_nsg_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: true
  }
  dependsOn: [
    virtualNetworks_app_prd_vnet_name_resource

  ]
}

resource virtualNetworks_managment_prd_vnet_name_management_subnet 'Microsoft.Network/virtualNetworks/subnets@2023-06-01' = {
  name: '${virtualNetworks_managment_prd_vnet_name}/management-subnet'
  properties: {
    addressPrefixes: [
      '10.10.10.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_management_subnet_nsg_name_resource.id
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.Storage'
        locations: [
          'westeurope'
          'northeurope'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: true
  }
  dependsOn: [
    virtualNetworks_managment_prd_vnet_name_resource

  ]
}

resource virtualNetworks_app_prd_vnet_name_managementServer_webServer_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-06-01' = {
  name: '${virtualNetworks_app_prd_vnet_name}/managementServer-webServer-peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_managment_prd_vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.10.10.0/24'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.10.10.0/24'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_app_prd_vnet_name_resource

  ]
}

resource virtualNetworks_managment_prd_vnet_name_managementServer_webServer_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-06-01' = {
  name: '${virtualNetworks_managment_prd_vnet_name}/managementServer-webServer-peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_app_prd_vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.20.20.0/24'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.20.20.0/24'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_managment_prd_vnet_name_resource

  ]
}

resource vaults_techgrounds_recovery_vault_name_project_recovery_endpoint_1132794570626989392_backup_58dc2e1a_3605_40a5_81c2_2de30e9bcd99 'Microsoft.RecoveryServices/vaults/privateEndpointConnections@2023-06-01' = {
  parent: vaults_techgrounds_recovery_vault_name_resource
  name: 'project-recovery-endpoint.1132794570626989392.backup.58dc2e1a-3605-40a5-81c2-2de30e9bcd99'
  location: 'westeurope'
  properties: {
    provisioningState: 'Succeeded'
    privateEndpoint: {
      id: privateEndpoints_project_recovery_endpoint_name_resource.id
    }
    groupIds: [
      'AzureBackup'
    ]
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'None'
      actionsRequired: 'None'
    }
  }
}
