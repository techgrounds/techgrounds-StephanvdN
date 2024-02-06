param location string
// param VmWebserver string
param adminUsername string
param NetworkInterfaceWeb string
param subnetApp string
param publicIPWebServerName string
param dnsLabelPrefix string = toLower('${VmScaleSetWebserver}-${uniqueString(resourceGroup().id)}')
param VmScaleSetWebserver string = 'VmScaleSetWebserver'
param ApplicationGatewayName string = 'ApplicationGatewayWeb'
param vnetApp string

// var installScript = loadFileAsBase64('installscript.sh')

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

var BackAddressPoolID = resourceId('Microsoft.Network/applicationGateways/backendAddressPools', ApplicationGatewayName, 'myBackendPool')

resource VirtualNetworkWeb 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: vnetApp
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

// resource ApplicationGateway 'Microsoft.Network/applicationGateways@2022-01-01' = {
//   name: ApplicationGatewayName
//   location: location
//   properties: {
//     sku: {
//       name: 'Standard_v2'
//       tier: 'Standard_v2'
//     }
//     gatewayIPConfigurations: [
//       {
//         name: 'appGatewayIPConfig'
//         properties: {
//           subnet: {
//             id: subnetApp
//           }
//         }
//       }
//     ]
//     frontendIPConfigurations: [
//       {
//         name: 'appGatewayIPConfig'
//         properties: {
//           privateIPAllocationMethod: 'Dynamic'
//           publicIPAddress: {
//             id: publicIpAddressWebServer.id
//           }
//         }
//       }
//     ]
//     frontendPorts: [
//       {
//         name: 'port_80'
//         properties: {
//           port: 80
//         }
//       }
//     ]
//     backendAddressPools: [
//       {
//         name: 'myBackendPool'
//         properties: {

//         }
//       }
//     ]
//     backendHttpSettingsCollection: [
//       {
//         name: 'myHTTPSetting'
//         properties: {
//           port: 80
//           protocol: 'Http'
//           cookieBasedAffinity: 'Disabled'
//           pickHostNameFromBackendAddress: false
//           requestTimeout: 20

//         }
//       }
//     ]
//     httpListeners: [
//       {
//         name: 'myListener'
//         properties: {
//           frontendIPConfiguration: {
//             id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', ApplicationGatewayName, 'appGwPublicFrontendIp')
//           }
//           frontendPort: {
//             id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', ApplicationGatewayName, 'port_80')
//           }
//           protocol: 'Http'
//           requireServerNameIndication: false
//         }
//       }
//     ]
//     requestRoutingRules: [
//       {
//         name: 'myRoutingRule'
//         properties: {
//           ruleType: 'Basic'
//           httpListener: {
//             id: resourceId('Microsoft.Network/applicationGateways/httpListeners', ApplicationGatewayName, 'myListener')
//           }
//           backendAddressPool: {
//             id: BackAddressPoolID

//           }
//           backendHttpSettings: {
//             id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', ApplicationGatewayName, 'myHTTPSetting')

//           }
//         }
//       }
//     ]
//     enableHttp2: false
//     autoscaleConfiguration: {
//       minCapacity: 1
//       maxCapacity: 3
//     }
//   }
//   dependsOn: [
//     VirtualNetworkWeb
//   ]
// }

resource VirtualMachineScaleSetWebserver 'Microsoft.Compute/virtualMachineScaleSets@2022-03-01' = {
  name: VmScaleSetWebserver
  location: location
  sku: {
    name: 'Standard_D2s_v3'
    tier: 'Standard'
    capacity: 1
  }
  zones: [
    '2'
  ]
  properties: {
    singlePlacementGroup: false
    orchestrationMode: 'Flexible'
    platformFaultDomainCount: 1
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: 'Project-Techgrounds'
        adminUsername: 'azureuser'
        linuxConfiguration: {
          disablePasswordAuthentication: true
          ssh: {
            publicKeys: [
              {
                path: '/home/azureuser/.ssh/authorized_keys'
                keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9tgl27jmiprWvxTKmatb846TAnFilwJM+Q3C3ysidnabj4qRYYtx56zHUQbxUl9WVbfYa8MjJ5lqwgNBFPIrHPIhUauRR7f7g0rHVx39k/XiM0De9B5Ur4f9YIb0W1l1r4dWXjCpfzB/9gNxkTQ3C+G+y4L/aJ+TU/2xUtrt0s+29DgHQ15rJJ7iUA7repe4/OTNh1b/Vgp7HWwtTmH/EuqwOpxUVkMZPM0Jp20N3aVPlVP2czT22h/XT1dQtpHpfrRwrAM8ZzLf8yNCOIr2J8K6gv8ysJzIYfNALJcljaCjBOFmVTziuKW1KA/GspOslg7kPBxwLb+kmNUZNs+nQgO6wbcbJYvdZqXJOEW5192s0+WBQ84x7kum4cboJ6aWvjcfOCi+VWTOAaLXABTSPE41CvMDUp5OHCq+YU7HXRIubZm5yySrZr8T0TBWfDMFOadaUkyDWhD/2vjjVXvkcPUXrmbhzg4q2ov8NqSaUZBVmj2yQT9aa09qxs9mOjHE= generated-by-azure'
              }
            ]
          }
          provisionVMAgent: true
          patchSettings: {
            patchMode: 'ImageDefault'
            assessmentMode: 'ImageDefault'
          }
        }
        secrets: []
        allowExtensionOperations: true
      }
      storageProfile: {
        osDisk: {
          osType: 'Linux'
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
          deleteOption: 'Delete'
          diskSizeGB: 30
        }
        imageReference: {
          publisher: 'canonical'
          offer: '0001-com-ubuntu-server-focal'
          sku: '20_04-lts-gen2'
          version: 'latest'
        }
      }
      networkProfile: {

        networkApiVersion: '2020-11-01'
        networkInterfaceConfigurations: [
          {
            name: 'VmScaleSetWebserver-Nic'
            properties: {
              primary: true
              enableAcceleratedNetworking: false
              enableIPForwarding: false
              deleteOption: 'Delete'
              ipConfigurations: [
                {
                  name: 'VmScaleSetWebserver-defaultIpConfiguration'
                  properties: {
                    privateIPAddressVersion: 'IPv4'
                    subnet: {
                      id: subnetApp
                    }
                    primary: true
                    applicationSecurityGroups: []
                    applicationGatewayBackendAddressPools: [

                    ]
                    publicIPAddressConfiguration: {
                      name: 'IpAddressConfig'
                      properties: {
                        deleteOption: 'Delete'
                        dnsSettings: {
                          domainNameLabel: dnsLabelPrefix
                        }
                      }
                    }
                  }
                }
              ]

            }
          }

        ]
      }

    }

  }
  dependsOn: [
    //ApplicationGateway
    publicIpAddressWebServer
  ]
}

// resource VirtualMachineWebserver 'Microsoft.Compute/virtualMachines@2022-03-01' = {
//   name: VmWebserver
//   location: location
//   zones: [
//     VmWebserverZone.zone
//     //'2'
//   ]
//   properties: {
//     hardwareProfile: {
//       vmSize: VmSizeVmWebserver.vmSize
//     }
//     storageProfile: {
//       imageReference: {
//         publisher: StorageProfileVMWebserver.publisher
//         offer: StorageProfileVMWebserver.offer
//         sku: StorageProfileVMWebserver.sku
//         version: StorageProfileVMWebserver.version
//       }
//       osDisk: {
//         osType: OsDiskVMWebserver.osType
//         createOption: OsDiskVMWebserver.createOption
//         caching: OsDiskVMWebserver.caching

//         deleteOption: OsDiskVMWebserver.deleteOption
//       }
//       dataDisks: []
//     }
//     osProfile: {
//       computerName: VmWebserver
//       adminUsername: adminUsername

//       linuxConfiguration: {
//         disablePasswordAuthentication: linuxConfig.disablePasswordAuthentication
//         ssh: {
//           publicKeys: [
//             {
//               path: linuxConfig.path
//               keyData: linuxConfig.keyData }
//           ]
//         }
//       }

//     }
//     networkProfile: {
//       networkInterfaces: [
//         {
//           id: networkInterfaceWebServer.id
//           properties: {
//             deleteOption: 'Delete'
//           }
//         }
//       ]
//     }
//   }
// }

// resource deploymenscript 'Microsoft.Compute/virtualMachines/runCommands@2022-03-01' = {
//   parent: VirtualMachineWebserver
//   name: 'installScript'
//   location: location
//   properties: {
//     source: {
//       script: '''
//       #!/bin/bash

// sudo apt-get update
// sudo apt install apache2 -y

// ufw allow 'Apache'

// sudo systemctl start apache2

// sudo systemctl enable apache2

// sudo systemctl restart apache2 

// sudo systemctl status apache2
//       '''
//     }
//   }
// }

output linuxconfigPath string = linuxConfig.path
output linuxconfigKeyData string = linuxConfig.keyData

// output VmWebserverOutput string = VirtualMachineWebserver.name
