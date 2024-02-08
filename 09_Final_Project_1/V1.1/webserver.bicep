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

param ssl_cert string = loadFileAsBase64('Keys/myCA.cer')
param gatewaySubnetName string = 'gateway_Subnet'
// param gatewaySubnetID string = resourceId('Microsoft.Network/virtualNetworks/subnets/', vnetApp, gatewaySubnetName)

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

var vmScaleSetName = toLower(substring('${VmScaleSetWebserver}${uniqueString(resourceGroup().id)}', 0, 9))
var backEndPoolName = '${vmScaleSetName}BackEndPool'

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

// resource networkInterfaceWebServer 'Microsoft.Network/networkInterfaces@2022-01-01' = {
//   name: NetworkInterfaceWeb
//   location: location
//   properties: {
//     ipConfigurations: [
//       {
//         name: NetworkInterfaceConfig.name
//         id: NetworkInterfaceWeb
//         type: NetworkInterfaceConfig.type
//         properties: {
//           privateIPAllocationMethod: NetworkInterfaceConfig.properties.privateIPAllocationMethod
//           publicIPAddress: {
//             id: publicIpAddressWebServer.id
//             properties: {
//               deleteOption: 'Delete'
//             }
//           }
//           subnet: {
//             id: VirtualNetworkWeb.properties.subnets[1].id
//           }
//           primary: NetworkInterfaceConfig.properties.primary
//           privateIPAddressVersion: NetworkInterfaceConfig.properties.privateIPAddressVersion
//         }
//       }
//     ]

//   }
// }

resource ApplicationGateway 'Microsoft.Network/applicationGateways@2022-01-01' = {
  name: ApplicationGatewayName
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 10
    }
    sslCertificates: [
      {
        name: 'mycert'
        properties: {
          data: loadFileAsBase64('Keys/certificate.pfx')
          password: 'Techgrounds'
        }
      }
    ]
    // trustedClientCertificates: [
    //   { name: 'test-cert'
    //     properties: {
    //       data: ssl_cert
    //     }
    //   }
    // ]
    backendAddressPools: [
      {
        name: backEndPoolName
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'backendSettings_collection'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 20

        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'frontendGatewayIP'
        properties: {
          publicIPAddress: {
            id: publicIpAddressWebServer.id
          }
        }

      }
      // {
      //   // name: 'FrontendPrivateIP'
      //   // properties: {
      //   //   privateIPAllocationMethod: 'Dynamic'
      //   //   subnet: {
      //   //     id: resourceId('Microsoft.Network/virtualNetworks/subnets/', subnetApp, gatewaySubnetName)
      //   //   }
      //   // }
      // }
    ]
    frontendPorts: [
      {
        name: 'HTTP_redirectPort'
        properties: {
          port: 80
        }

      }
      {
        name: 'HTTPS_port'
        properties: {
          port: 443
        }
      }

    ]

    gatewayIPConfigurations: [
      {
        name: 'GatewayIP'
        properties: {
          subnet: {
            id: VirtualNetworkWeb.properties.subnets[1].id
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'redirect_HTTPtoHTTPS_listener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', ApplicationGatewayName, 'frontendGatewayIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', ApplicationGatewayName, 'HTTP_redirectPort')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
      {
        name: 'HTTPS_Listener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', ApplicationGatewayName, 'frontendGatewayIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts/', ApplicationGatewayName, 'HTTPS_port')
          }
          protocol: 'Https'
          requireServerNameIndication: false
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', ApplicationGatewayName, 'mycert')
          }

        }
      }
    ]
    listeners: []
    requestRoutingRules: [
      {
        name: 'HTTPS_RoutingRule'
        properties: {
          ruleType: 'Basic'
          priority: 120
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', ApplicationGatewayName, 'HTTPS_listener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', ApplicationGatewayName, backEndPoolName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection/', ApplicationGatewayName, 'backendSettings_collection')
          }
        }
      }
      {
        name: 'HTTP_routingRule'
        properties: {
          ruleType: 'Basic'
          priority: 110
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', ApplicationGatewayName, 'redirect_HTTPtoHTTPS_listener')
          }
          redirectConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/redirectConfigurations', ApplicationGatewayName, 'HTTP_to_HTTPS_redirection')
          }

        }
      }

    ]
    // probes: [
    //   {
    //     name: 'gatewayHealthProbe'
    //     properties: {
    //       host: '127.0.0.1'
    //       interval: 15
    //       path: '/'
    //       port: 443
    //       protocol: 'Https'
    //       timeout: 10
    //       unhealthyThreshold: 10
    //       match: {
    //         statusCodes: [
    //           '200'
    //         ]
    //       }
    //     }
    //   }
    // ]

    redirectConfigurations: [
      {
        name: 'HTTP_to_HTTPS_redirection'
        properties: {
          targetListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', ApplicationGatewayName, 'HTTPS_listener')
          }
          redirectType: 'Permanent'
          includePath: true
          includeQueryString: true
        }
      }
    ]

    // enableHttp2: true
    // autoscaleConfiguration: {
    //   minCapacity: 1
    //   maxCapacity: 3
    // }
  }
  // dependsOn: [
  //   VirtualNetworkWeb

  // ]
}

resource VirtualMachineScaleSetWebserver 'Microsoft.Compute/virtualMachineScaleSets@2022-03-01' = {
  name: VmScaleSetWebserver
  location: location
  sku: {
    name: 'Standard_D2s_v3'
    tier: 'Standard'
    capacity: 3
  }
  zones: [
    '2'
  ]
  properties: {
    automaticRepairsPolicy: {
      enabled: true
      gracePeriod: 'PT10M'
    }
    overprovision: true
    upgradePolicy: {
      mode: 'Automatic'
    }
    singlePlacementGroup: false
    platformFaultDomainCount: 1
    virtualMachineProfile: {
      extensionProfile: {
        extensions: [
          {
            name: 'healthExtention'
            properties: {
              autoUpgradeMinorVersion: true
              publisher: 'Microsoft.ManagedServices'
              type: 'ApplicationHealthLinux'
              typeHandlerVersion: '1.0'
              settings: {
                protocol: 'http'
                port: 80
              }
            }
          }
        ]
      }
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
        }
        imageReference: {
          publisher: 'canonical'
          offer: '0001-com-ubuntu-server-focal'
          sku: '20_04-lts-gen2'
          version: 'latest'
        }
      }
      securityProfile: {
        encryptionAtHost: true
      }
      osProfile: {
        computerNamePrefix: vmScaleSetName
        adminUsername: adminUsername
        // customData: 
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
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'VmScaleSetWebserver-Nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'VmScaleSetWebserver-defaultIpConfiguration'
                  properties: {
                    subnet: {
                      id: resourceId('Microsoft.Network/virtualNetworks/subnets/', vnetApp, 'GatewaySubnetTest')
                      // subnetApp
                    }
                    applicationGatewayBackendAddressPools: [
                      {
                        id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools/', ApplicationGatewayName, backEndPoolName)
                      }

                    ]

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

    ApplicationGateway
  ]
}

resource autoscale 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: 'autoscaler'
  location: location
  properties: {
    targetResourceUri: VirtualMachineScaleSetWebserver.id
    enabled: true
    profiles: [
      {
        name: 'scaler'
        capacity: {
          default: '1'
          maximum: '3'
          minimum: '1'
        }
        rules: [
          {
            metricTrigger: {
              operator: 'GreaterThan'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeAggregation: 'Average'
              metricResourceUri: VirtualMachineScaleSetWebserver.id
              timeWindow: 'PT5M'
              threshold: 50
              metricName: 'Percentag CPU'
            }
            scaleAction: {
              type: 'ChangeCount'
              direction: 'Increase'
              cooldown: 'PT5M'
            }

          }
          {
            metricTrigger: {
              operator: 'LessThan'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeAggregation: 'Average'
              metricResourceUri: VirtualMachineScaleSetWebserver.id
              timeWindow: 'PT3M'
              threshold: 30
              metricName: 'Percentage CPU'
            }
            scaleAction: {
              type: 'ChangeCount'
              direction: 'Decrease'
              cooldown: 'PT3M'
              value: '1'
            }
          }
        ]
      }
    ]
  }
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
