param mySqlServerName string = 'mySqlServerName23${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param vnetApp string

param virtualNetworkRuleName string = 'virtualNetworkRuleName'

@secure()
param administratorLogin string = 'Techgrounds'

@secure()
param administratorLoginPassword string = 'MoetNogEenWachtwoordVerzinnen12?*'

resource VirtualNetworkWeb 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: vnetApp
}

resource mySqlServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: mySqlServerName
  location: location
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    capacity: 2
    size: '5120'
    family: 'Gen5'
  }
  properties: {
    createMode: 'Default'
    version: '8.0'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    storageProfile: {
      storageMB: 5120
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
  }
}

resource mySqlDatabase 'Microsoft.DBforMySQL/servers/databases@2017-12-01' = {
  name: '${mySqlServer.name}name-sqldb'
  parent: mySqlServer
}

resource virtualNetworkRules 'Microsoft.DBforMySQL/servers/virtualNetworkRules@2017-12-01' = {
  name: '${virtualNetworkRuleName}hiermoetiets'
  parent: mySqlServer
  properties: {
    virtualNetworkSubnetId: VirtualNetworkWeb.properties.subnets[1].id
    ignoreMissingVnetServiceEndpoint: true
  }
}
