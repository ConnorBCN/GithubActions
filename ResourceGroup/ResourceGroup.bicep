targetScope = 'subscription'
param Location string = 'Uk West'
param companyPrefix string = 'bicep'
 
var ResourceGroups = [  
  'rg-${companyPrefix}-Dev'
  'rg-${companyPrefix}-Domain'
  'rg-${companyPrefix}-Testing'
  'rg-${companyPrefix}-Storage'
  'rg-${companyPrefix}-Network' 
]
 
resource resourcegroups 'Microsoft.Resources/resourceGroups@2021-01-01' = [for ResourceGroup in ResourceGroups: {
  location: Location
  name: ResourceGroup
}]
