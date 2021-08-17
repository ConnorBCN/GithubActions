module CitrixvNet './Template/vNet.bicep' = {
  name: 'Citrix-vNet-Deployment'
  params: {
    dnsServers: Citrix_vNet_dnsServers
     Location: Location
     Subnets: Citrix_vNet_Subnets
     Name: Citrix_vNetName
     Prefix: Citrix_vNet_Prefix
  }
  dependsOn: [
    SharedservicevNet
  ]
  scope: resourceGroup(Citrix_ResourceGroup)
}
 
module SharedservicevNet './Template/vNet.bicep' = {
  name: 'Sharedservice-vNet-Deployment'
  params: {
    dnsServers: Sharedservice_vNet_dnsServers
     Location: Location
     Subnets: Sharedservice_vNet_Subnets
     Name: Sharedservice_vNet_Name
     Prefix: Sharedservice_vNet_Prefix
  }
  scope: resourceGroup(Sharedservice_ResourceGroup)
}
