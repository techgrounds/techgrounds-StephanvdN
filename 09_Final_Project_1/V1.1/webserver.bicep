param location string
param adminUsername string
param publicIPWebServerName string
param dnsLabelPrefix string = toLower('${VmScaleSetWebserver}-${uniqueString(resourceGroup().id)}')
param VmScaleSetWebserver string = 'VmScaleSetWebserver'
param ApplicationGatewayName string = 'ApplicationGatewayWeb'
param vnetApp string
param networkSecurityGroupAppSubnet string
param instanceCount int = 3

var VmWebserverZone = {
  zone: '2'
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

var vmScaleSetName = toLower(substring('${VmScaleSetWebserver}${uniqueString(resourceGroup().id)}', 0, 9))
var backEndPoolName = '${vmScaleSetName}BackEndPool'

resource VirtualNetworkWeb 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: vnetApp
}

resource NSGVirtualNetworkWeb 'Microsoft.Network/networkSecurityGroups@2022-01-01' existing = {
  name: networkSecurityGroupAppSubnet
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

resource ApplicationGateway 'Microsoft.Network/applicationGateways@2022-01-01' = {
  name: ApplicationGatewayName
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 3
    }

    sslPolicy: {
      policyType: 'Custom'
      minProtocolVersion: 'TLSv1_2'
      cipherSuites: [
        'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
        'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
        'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
        'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
      ]
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
          requestTimeout: 600
          pickHostNameFromBackendAddress: true
          probeEnabled: true
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', ApplicationGatewayName, 'Http-HealthProbe')
          }

        }
      }
      {
        name: 'backendSettings_collection_443'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          probeEnabled: true
          pickHostNameFromBackendAddress: true
          requestTimeout: 600
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', ApplicationGatewayName, 'HttpsHealthProbe')
          }

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
    probes: [
      {
        name: 'HttpsHealthProbe'
        properties: {
          host: '127.0.0.1'
          interval: 30
          path: '/'
          port: 443
          protocol: 'Https'
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          match: {
            statusCodes: [
              '399'
            ]
          }
        }
      }

      {
        name: 'Http-HealthProbe'
        properties: {
          host: '127.0.0.1'
          interval: 30
          path: '/'
          port: 80
          protocol: 'Http'
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          match: {
            statusCodes: [
              '200'
            ]
          }

        }

      }
    ]

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

  }
  dependsOn: [
    VirtualNetworkWeb

    NSGVirtualNetworkWeb

  ]
}

resource VirtualMachineScaleSetWebserver 'Microsoft.Compute/virtualMachineScaleSets@2022-03-01' = {

  name: VmScaleSetWebserver
  location: location
  sku: {
    name: 'Standard_D2s_v3'
    tier: 'Standard'
    capacity: int(instanceCount)
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
    singlePlacementGroup: true
    platformFaultDomainCount: 1
    virtualMachineProfile: {
      extensionProfile: {
        extensions: [
          {
            name: 'healthExtention'
            properties: {
              autoUpgradeMinorVersion: true
              enableAutomaticUpgrade: true
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
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }

        }
        imageReference: {
          publisher: 'canonical'
          offer: '0001-com-ubuntu-server-focal'
          sku: '20_04-lts-gen2'
          version: 'latest'
        }
      }

      osProfile: {
        computerNamePrefix: vmScaleSetName
        adminUsername: adminUsername
        adminPassword: 'Techgrounds'
        customData: loadFileAsBase64('installscript.sh')
        linuxConfiguration: {
          disablePasswordAuthentication: true
          ssh: {
            publicKeys: [
              {
                path: linuxConfig.path
                keyData: linuxConfig.keyData
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
              enableAcceleratedNetworking: false
              ipConfigurations: [
                {
                  name: 'VmScaleSetWebserver-defaultIpConfiguration'
                  properties: {
                    subnet: {
                      id: VirtualNetworkWeb.properties.subnets[0].id

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
    NSGVirtualNetworkWeb
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
              metricResourceUri: ApplicationGateway.id
              timeWindow: 'PT1M'
              threshold: 75000
              metricName: 'Throughput'
              metricNamespace: 'microsoft.network/applicationgateways'
              dividePerInstance: false

            }
            scaleAction: {
              type: 'ChangeCount'
              direction: 'Increase'
              cooldown: 'PT1M'
              value: '1'
            }

          }
          {
            metricTrigger: {
              operator: 'LessThan'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeAggregation: 'Average'
              metricResourceUri: ApplicationGateway.id
              timeWindow: 'PT1M'
              threshold: 20000
              metricName: 'Throughput'
              metricNamespace: 'microsoft.network/applicationgateways'
              dividePerInstance: false

            }
            scaleAction: {
              type: 'ChangeCount'
              direction: 'Decrease'
              cooldown: 'PT1M'
              value: '1'
            }
          }
          // {
          //   metricTrigger: {
          //     operator: 'GreaterThan'
          //     timeGrain: 'PT1M'
          //     statistic: 'Average'
          //     timeAggregation: 'Average'
          //     metricResourceUri: VirtualMachineScaleSetWebserver.id
          //     timeWindow: 'PT10M'
          //     threshold: 80
          //     metricName: 'Percentage CPU'
          //     // metricNamespace: 'Standard metrics'
          //     dividePerInstance: false
          //   }
          //   scaleAction: {
          //     type: 'ChangeCount'
          //     direction: 'Increase'
          //     cooldown: 'PT5M'
          //     value: '1'
          //   }

          // }
          {
            metricTrigger: {
              operator: 'LessThan'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeAggregation: 'Average'
              metricResourceUri: VirtualMachineScaleSetWebserver.id
              timeWindow: 'PT5M'
              threshold: 30
              metricName: 'Percentage CPU'
              // metricNamespace: 'Standard metrics'
              dividePerInstance: false
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
    predictiveAutoscalePolicy: {
      scaleMode: 'Disabled'
      scaleLookAheadTime: 'PT14M'
    } }

}

output linuxconfigPath string = linuxConfig.path
output linuxconfigKeyData string = linuxConfig.keyData
