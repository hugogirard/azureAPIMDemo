param location string
param resourceName string

resource apiCenter 'Microsoft.ApiCenter/services@2024-03-01' = {
  location: location
  name: resourceName
  properties: {}
}
