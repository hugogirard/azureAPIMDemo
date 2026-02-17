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

module acr 'br/public:avm/res/container-registry/registry:0.10.0' = {
  scope: rg
  name: 'acr'
  params: {
    #disable-next-line BCP334
    name: 'acr${replace(suffix,'-','')}'
    acrSku: 'Standard'
    acrAdminUserEnabled: true
    publicNetworkAccess: 'Enabled'
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

/********* Hosting app ***********/
module serverfarm 'br/public:avm/res/web/serverfarm:0.6.0' = {
  scope: rg
  name: 'serverFarm'
  params: {
    name: 'asp-${suffix}'
    location: location
    kind: 'linux'
    reserved: true
    zoneRedundant: false
    skuName: 'B1'
  }
}
