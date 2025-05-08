param publisherEmail string
param apimSku string
param location string
param environment string
@minLength(3)
param suffix string

// The Azure Container Registry
module containerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  params: {
    name: 'acr${suffix}'
    acrSku: 'Premium'
    acrAdminUserEnabled: true
    publicNetworkAccess: 'Enabled'
    exportPolicyStatus: 'enabled'
  }
}

module apim 'br/public:avm/res/api-management/service:0.9.1' = {
  name: 'apim'
  params: {
    name: 'apigw-${suffix}-${environment}'
    publisherEmail: publisherEmail
    publisherName: 'Contoso'
    sku: apimSku
  }
}

// Workspace for application insights
module workspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  params: {
    name: 'log-${suffix}-${environment}'
    dailyQuotaGb: 2
    skuName: 'PerGB2018'
  }
}

module appinsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'appinsights'
  params: {
    name: 'api-${suffix}-${environment}'
    workspaceResourceId: workspace.outputs.resourceId
    location: location
  }
}

var aspNames = [
  'asp-weather-api-${suffix}-${environment}'
  'asp-pizza-api-${suffix}-${environment}'
]

// Creating Two App Service Plan in the shared ressource group
module serverfarmDev 'br/public:avm/res/web/serverfarm:0.4.1' = [
  for name in aspNames: {
    name: name
    params: {
      name: name
      kind: 'linux'
      skuName: 'P1V3'
    }
  }
]
