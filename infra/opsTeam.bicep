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

@allowed([
  'Premium'
  'Developer'
])
@description('APIM SKU')
param apimSku string

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
    name: 'apigw-${suffix}'
    publisherEmail: publisherEmail
    publisherName: 'Contoso'
    sku: apimSku
  }
}

// Workspace for application insights
module workspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  scope: rgSharedService
  params: {
    name: 'log-${suffix}'
    dailyQuotaGb: 2
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

var aspNames = [
  'asp-weather-api-${suffix}'
  'asp-pizza-api-${suffix}'
]

// Creating Two App Service Plan in the shared ressource group
module serverfarm 'br/public:avm/res/web/serverfarm:0.4.1' = [
  for name in aspNames: {
    scope: rgSharedService
    name: name
    params: {
      name: name
      kind: 'linux'
      skuName: 'P1V3'
    }
  }
]
