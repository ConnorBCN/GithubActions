param location string = 'UKWest'
targetScope = 'subscription'
 
resource resourcegroups 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  location: location
  name: 'rg-bicep-001'
}
//test
