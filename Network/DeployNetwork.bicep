
targetScope = 'subscription'
param companyPrefix string = 'bicep'
var Location = 'Uk West'
var Network_ResourceGroup = 'rg-${companyPrefix}-Network'
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








module MyvNet './Template/vNet.bicep' = {
  name: 'My-vNet-Deployment'
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
  name: 'Test-vNet-Deployment'
  params: {
    //dnsServers: vNet_dnsServers
     Location: Location
     Subnets: Hub_vNet_Subnets
     Name: Hub_vNet_Name
     Prefix: Hub_vNet_Prefix
  }
  scope: resourceGroup(Network_ResourceGroup)
}



module MyPeering './Template/Peering.bicep' = {
  name: 'MyvNetPeering'
  params: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    remoteResourceGroup: 'rg-${companyPrefix}-network'
    remoteVirtualNetworkName: 'vnet-${companyPrefix}-Test-001'
    useRemoteGateways: false
    virtualNetworkName: MyvNet.outputs.name
  }
  dependsOn: [
    MyvNet
  ]
  scope: resourceGroup(Prod_ResourceGroup)
}
module TestPeering './Template/Peering.bicep' = {
  name: 'TestvNetPeering'
  params: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    remoteResourceGroup: 'rg-${companyPrefix}-network'
    remoteVirtualNetworkName: 'vnet-${companyPrefix}-001'
    useRemoteGateways: false
    virtualNetworkName: HubvNet.outputs.name
  }
  dependsOn: [
    MyPeering
  ]
  scope: resourceGroup(Network_ResourceGroup)
}
