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

resource rgSharedServiceDev 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: '${sharedRgName}-dev'
  location: location
}

resource rgteamWeatherDev 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: '${teamWeatherRgName}-dev'
  location: location
}

resource rgteamPizzaDev 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: '${teamPizzaRgName}-dev'
  location: location
}

resource rgSharedServiceProd 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: '${sharedRgName}-prod'
  location: location
}

resource rgteamWeatherProd 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: '${teamWeatherRgName}-prod'
  location: location
}

resource rgteamPizzaProd 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: '${teamPizzaRgName}-prod'
  location: location
}

/* Creation DEV environment */

module devSharedServices 'modules/sharedServices.bicep' = {
  scope: rgSharedServiceDev
  params: {
    location: location
    apimSku: apimSku
    environment: 'dev'
    publisherEmail: publisherEmail
    suffix: uniqueString(rgSharedServiceDev.id)
  }
}

/* Creation PROD environment */

module ProdSharedServices 'modules/sharedServices.bicep' = {
  scope: rgSharedServiceProd
  params: {
    location: location
    apimSku: apimSku
    environment: 'prod'
    publisherEmail: publisherEmail
    suffix: uniqueString(rgSharedServiceProd.id)
  }
}
