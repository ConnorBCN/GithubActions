param location string = 'UKWest'
targetScope = 'subscription'
  'rg-${companyPrefix}-Network' 
 
resource resourcegroups 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  location: location
  name: 'rg-bicep-001'
}
//testconnmorr
