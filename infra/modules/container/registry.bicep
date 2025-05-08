param location string
@minLength(3)
param suffix string

resource containerregistry 'Microsoft.ContainerRegistry/registries@2025-04-01' = {
  name: 'acr${suffix}'
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    adminUserEnabled: true
    policies: {
      exportPolicy: {
        status: 'disabled'
      }
    }
  }
}

output resourceName string = containerregistry.name
output resourceId string = containerregistry.id
