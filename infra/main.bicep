targetScope = 'subscription'

@description('')
@allowed([
  'canadacentral'
  'centralus'
])
param location string
param resourceGroupName string

param publisherName string
param publisherEmail string

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
}

var suffix = uniqueString(rg.id)

module apim 'br/public:avm/res/api-management/service:0.14.0' = {
  scope: rg
  name: 'apimdeployment'
  params: {
    name: 'apim-${suffix}'
    publisherEmail: publisherEmail
    publisherName: publisherName
    enableDeveloperPortal: true
    sku: 'StandardV2'
  }
}

module apiCenter 'modules/api_center.bicep' = {
  scope: rg
  name: 'apicenter'
  params: {
    location: location
    resourceName: 'api-center-${suffix}'
  }
}
