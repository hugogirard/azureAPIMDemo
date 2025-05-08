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
module acr 'modules/container/registry.bicep' = {
  scope: rg
  params: {
    location: location
    suffix: suffix
  }
}

output acrResourceName string = acr.outputs.resourceName
