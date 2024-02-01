param location string
param VmWebserver string
param adminUsername string
param NetworkInterfaceWeb string
param subnetApp string
param publicIPWebServerName string
param dnsLabelPrefix string = toLower('${VmWebserver}-${uniqueString(resourceGroup().id)}')

var installScript = loadFileAsBase64('installscript.sh')

var VmWebserverZone = {
  zone: '2'
}

var VmSizeVmWebserver = {
  vmSize: 'Standard_DS1_v2'
}

var StorageProfileVMWebserver = {
  publisher: 'canonical'
  offer: '0001-com-ubuntu-server-focal'
  sku: '20_04-lts-gen2'
  version: 'latest'
}
var OsDiskVMWebserver = {
  osType: 'Linux'
  createOption: 'FromImage'
  caching: 'ReadWrite'
  deleteOption: 'Delete'
}

var linuxConfig = {
  disablePasswordAuthentication: true
  path: '/home/${adminUsername}/.ssh/authorized_keys'
  keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9tgl27jmiprWvxTKmatb846TAnFilwJM+Q3C3ysidnabj4qRYYtx56zHUQbxUl9WVbfYa8MjJ5lqwgNBFPIrHPIhUauRR7f7g0rHVx39k/XiM0De9B5Ur4f9YIb0W1l1r4dWXjCpfzB/9gNxkTQ3C+G+y4L/aJ+TU/2xUtrt0s+29DgHQ15rJJ7iUA7repe4/OTNh1b/Vgp7HWwtTmH/EuqwOpxUVkMZPM0Jp20N3aVPlVP2czT22h/XT1dQtpHpfrRwrAM8ZzLf8yNCOIr2J8K6gv8ysJzIYfNALJcljaCjBOFmVTziuKW1KA/GspOslg7kPBxwLb+kmNUZNs+nQgO6wbcbJYvdZqXJOEW5192s0+WBQ84x7kum4cboJ6aWvjcfOCi+VWTOAaLXABTSPE41CvMDUp5OHCq+YU7HXRIubZm5yySrZr8T0TBWfDMFOadaUkyDWhD/2vjjVXvkcPUXrmbhzg4q2ov8NqSaUZBVmj2yQT9aa09qxs9mOjHE= generated-by-azure'
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
  name: 'ipconfig'
  type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
  properties: {
    privateIPAllocationMethod: 'Dynamic'
    primary: true
    privateIPAddressVersion: 'IPv4'

  }

}

resource publicIpAddressWebServer 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIPWebServerName
  location: location
  sku: {
    name: IPAddressConfig.sku.name
    tier: IPAddressConfig.sku.tier
  }
  zones: [
    VmWebserverZone.zone
  ]
  properties: {
    publicIPAddressVersion: IPAddressConfig.properties.publicIPAddressVersion
    publicIPAllocationMethod: IPAddressConfig.properties.publicIPAllocationMethod
    idleTimeoutInMinutes: IPAddressConfig.properties.idleTimeoutInMinutes
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }

}

resource networkInterfaceWebServer 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: NetworkInterfaceWeb
  location: location
  properties: {
    ipConfigurations: [
      {
        name: NetworkInterfaceConfig.name
        id: NetworkInterfaceWeb
        type: NetworkInterfaceConfig.type
        properties: {
          privateIPAllocationMethod: NetworkInterfaceConfig.properties.privateIPAllocationMethod
          publicIPAddress: {
            id: publicIpAddressWebServer.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: subnetApp
          }
          primary: NetworkInterfaceConfig.properties.primary
          privateIPAddressVersion: NetworkInterfaceConfig.properties.privateIPAddressVersion
        }
      }
    ]

  }
}

resource VirtualMachineWebserver 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: VmWebserver
  location: location
  zones: [
    VmWebserverZone.zone
    //'2'
  ]
  properties: {
    hardwareProfile: {
      vmSize: VmSizeVmWebserver.vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: StorageProfileVMWebserver.publisher
        offer: StorageProfileVMWebserver.offer
        sku: StorageProfileVMWebserver.sku
        version: StorageProfileVMWebserver.version
      }
      osDisk: {
        osType: OsDiskVMWebserver.osType
        createOption: OsDiskVMWebserver.createOption
        caching: OsDiskVMWebserver.caching

        deleteOption: OsDiskVMWebserver.deleteOption
      }
      dataDisks: []
    }
    osProfile: {
      computerName: VmWebserver
      adminUsername: adminUsername

      linuxConfiguration: {
        disablePasswordAuthentication: linuxConfig.disablePasswordAuthentication
        ssh: {
          publicKeys: [
            {
              path: linuxConfig.path
              keyData: linuxConfig.keyData }
          ]
        }
      }

    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceWebServer.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}
/*

resource deploymenscript 'Microsoft.Compute/virtualMachines/runCommands@2022-03-01' = {
  parent: VirtualMachineWebserver
  name: 'installScript'
  location: location
  properties: {
    source: {
      script: installScript
    }
  }
}

*/

output linuxconfigPath string = linuxConfig.path
output linuxconfigKeyData string = linuxConfig.keyData
