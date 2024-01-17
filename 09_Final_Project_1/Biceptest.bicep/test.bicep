param appname string = 'partyapp'
param environmentType string = 'test'
param instance string = '001'

//Storage account

resource pictureStorage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'st${appname}${environmentType}${instance}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }

  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
  }

}

//create a container
resource profileContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${pictureStorage.name}/default/profile-pictures'
  dependsOn: [

  ]
}
