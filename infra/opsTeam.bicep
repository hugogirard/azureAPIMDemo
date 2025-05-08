targetScope = 'subscription'

@allowed([
  'canadaeast'
  'canadacentral'
  'eastus'
  'westus'
])
param location string

@description('The name of the shared service resource group')
param sharedRgName string

resource rg 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: sharedRgName
  location: location
}

var suffix = uniqueString(rg.id)

// The Azure Container Registry
module containerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  scope: rg
  params: {
    name: 'acr${suffix}'
    acrSku: 'Premium'
    acrAdminUserEnabled: true
    publicNetworkAccess: 'Enabled'
    exportPolicyStatus: 'disabled'
  }
}
