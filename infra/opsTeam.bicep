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

@description('The name of the weather team resource group')
param teamWeatherRgName string

@description('The name of the resource group for the pizza team')
param teamPizzaRgName string

@description('The publisher email for the APIM')
param publisherEmail string

resource rgSharedService 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: sharedRgName
  location: location
}

resource rgteamWeather 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: teamWeatherRgName
  location: location
}

resource rgteamPizza 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: teamPizzaRgName
  location: location
}

var suffix = uniqueString(rgSharedService.id)

// The Azure Container Registry
module containerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  scope: rgSharedService
  params: {
    name: 'acr${suffix}'
    acrSku: 'Premium'
    acrAdminUserEnabled: true
    publicNetworkAccess: 'Enabled'
    exportPolicyStatus: 'enabled'
  }
}

module apim 'br/public:avm/res/api-management/service:0.9.1' = {
  scope: rgSharedService
  name: 'apim'
  params: {
    name: 'apim-${suffix}'
    publisherEmail: publisherEmail
    publisherName: 'Contoso'
    sku: 'Premium'
  }
}

// Creating the VNET and subnet for the Container App Environment
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  scope: rgSharedService
  name: 'vnet-shared-services'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'snet-aca'
        addressPrefix: '10.0.1.0/24'
      }
    ]
    name: 'vnet-shared-services'
    // Non-required parameters
    location: location
  }
}

// Workspace for application insights
module workspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  scope: rgSharedService
  params: {
    name: 'log-${suffix}'
    dailyQuotaGb: 2
    dataRetention: 10
    skuName: 'PerGB2018'
  }
}

module appinsights 'br/public:avm/res/insights/component:0.6.0' = {
  scope: rgSharedService
  name: 'appinsights'
  params: {
    name: 'api-${suffix}'
    workspaceResourceId: workspace.outputs.resourceId
    location: location
  }
}

// Creating Azure Container App Environment
