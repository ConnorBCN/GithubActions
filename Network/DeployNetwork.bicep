
targetScope = 'subscription'
param companyPrefix string = 'bicep'
var Location = 'Uk West'
var Hub_ResourceGroup = 'rg-${companyPrefix}-Network'
var Hub_vNet_Name = 'vnet-${companyPrefix}-Hub'
var Hub_vNet_Prefix = '10.16.0.0/16'
var Hub_vNet_Subnets = [
  {
    name: 'GatewaySubnet'
    prefix: '10.16.0.0/26'
  }
  {
    name: 'snet-${companyPrefix}-DomainServices'
    prefix: '10.16.1.0/24'
  }  
  {
    name: 'snet-${companyPrefix}-SharedResources'
    prefix: '10.16.2.0/24'
  }    
]
//var Test_vNet_dnsServers = [
 // '192.168.10.10'
//]
var Prod_ResourceGroup = 'rg-${companyPrefix}-Network'
var Prod_vNetName = 'vnet-${companyPrefix}-Production'
var Prod_vNet_Prefix = '10.17.0.0/16'
var Prod_vNet_Subnets = [
  {
    name: 'snet-${companyPrefix}-AVD'
    prefix: '10.17.1.0/24'
  }
  {
    name: 'snet-${companyPrefix}-Workload'
    prefix: '10.17.2.0/24'
  }
  {
    name: 'snet-${companyPrefix}-Application'
    prefix: '10.17.3.0/24'
  }
]
//var My_vNet_dnsServers = [
  //'192.168.10.10'
//]








module ProdvNet './Template/vNet.bicep' = {
  name: 'Prod-vNet-Deployment'
  params: {
    //dnsServers: vNet_dnsServers
     Location: Location
     Subnets: Prod_vNet_Subnets
     Name: Prod_vNetName
     Prefix: Prod_vNet_Prefix
  }
  dependsOn: [
    HubvNet
  ]
  scope: resourceGroup(Prod_ResourceGroup)
}
 
module HubvNet './Template/vNet.bicep' = {
  name: 'Hub-vNet-Deployment'
  params: {
    //dnsServers: vNet_dnsServers
     Location: Location
     Subnets: Hub_vNet_Subnets
     Name: Hub_vNet_Name
     Prefix: Hub_vNet_Prefix
  }
  scope: resourceGroup(Hub_ResourceGroup)
}



module ProdPeering './Template/Peering.bicep' = {
  name: 'ProdvNetPeering'
  params: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    remoteResourceGroup: 'rg-${companyPrefix}-network'
    remoteVirtualNetworkName: 'vnet-${companyPrefix}-prod'
    useRemoteGateways: false
    virtualNetworkName: ProdvNet.outputs.name
  }
  dependsOn: [
    ProdvNet
  ]
  scope: resourceGroup(Prod_ResourceGroup)
}
module HubPeering './Template/Peering.bicep' = {
  name: 'HubvNetPeering'
  params: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    remoteResourceGroup: 'rg-${companyPrefix}-network'
    remoteVirtualNetworkName: 'vnet-${companyPrefix}-Prod'
    useRemoteGateways: false
    virtualNetworkName: HubvNet.outputs.name
  }
  dependsOn: [
    ProdPeering
  ]
  scope: resourceGroup(Hub_ResourceGroup)
}
