param location string
param NetworkInterfaceManagement string
param adminUsername string

@description('Password Managementserver')
@secure()
param adminPassword string
param publicIPAddressManagementServerName string
param subnetManagement string
param VmManagementserver string
param dsnLabelPrefix string = toLower('${VmManagementserver}-${uniqueString(resourceGroup().id)}')

var VmManagementserverZone = {
  zone: '1'
}

var VmSizeVmManagementserver = {
  vmSize: 'Standard_DS1_v2'
}

var StorageProfileVMManagementserver = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2022-datacenter-azure-edition-hotpatch'
  version: 'latest'
}

var OsDiskVMManagementserver = {
  osType: 'Windows'
  createOption: 'FromImage'
  caching: 'ReadWrite'
  deleteOption: 'Delete'

}
var IPAddressConfig = {
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

var NetworkInterfaceConfig = {
  name: 'ipconfig1'
  type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
  properties: {
    privateIPAllocationMethod: 'Dynamic'
    primary: true
    privateIPAddressVersion: 'IPv4'

  }

}

resource publicIpAddressManagementServer 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIPAddressManagementServerName
  location: location
  sku: {
    name: IPAddressConfig.sku.name
    tier: IPAddressConfig.sku.tier
  }
  zones: [
    VmManagementserverZone.zone
  ]
  properties: {
    publicIPAddressVersion: IPAddressConfig.properties.publicIPAddressVersion
    publicIPAllocationMethod: IPAddressConfig.properties.publicIPAllocationMethod
    idleTimeoutInMinutes: IPAddressConfig.properties.idleTimeoutInMinutes
    dnsSettings: {
      domainNameLabel: dsnLabelPrefix
    }
  }
}

resource networkInterfaceManagementServer 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: NetworkInterfaceManagement
  location: location
  properties: {
    ipConfigurations: [
      {
        name: NetworkInterfaceConfig.name
        id: NetworkInterfaceManagement
        type: NetworkInterfaceConfig.type
        properties: {

          privateIPAllocationMethod: NetworkInterfaceConfig.properties.privateIPAllocationMethod
          publicIPAddress: {
            id: publicIpAddressManagementServer.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: subnetManagement
          }
          primary: NetworkInterfaceConfig.properties.primary
          privateIPAddressVersion: NetworkInterfaceConfig.properties.privateIPAddressVersion

        }
      }
    ]
  }
}

resource VirtualMachineManagementServer 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: VmManagementserver
  location: location
  zones: [
    VmManagementserverZone.zone
  ]
  properties: {
    hardwareProfile: {
      vmSize: VmSizeVmManagementserver.vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: StorageProfileVMManagementserver.publisher
        offer: StorageProfileVMManagementserver.offer
        sku: StorageProfileVMManagementserver.sku
        version: StorageProfileVMManagementserver.version
      }
      osDisk: {
        osType: OsDiskVMManagementserver.osType
        createOption: OsDiskVMManagementserver.createOption
        caching: OsDiskVMManagementserver.caching
        deleteOption: OsDiskVMManagementserver.deleteOption
      }
      dataDisks: []
    }
    osProfile: {
      computerName: VmManagementserver
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceManagementServer.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}

output VmManagementserverOutput string = VirtualMachineManagementServer.name
