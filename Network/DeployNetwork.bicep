
targetScope = 'subscription'
param companyPrefix string = 'bicep'
var Location = 'Uk West'
var Test_ResourceGroup = 'rg-${companyPrefix}-Network'
var Test_vNet_Name = 'vnet-${companyPrefix}-Test-001'
var Test_vNet_Prefix = '10.16.0.0/16'
var Test_vNet_Subnets = [
  {
    name: 'GatewaySubnet'
    prefix: '10.16.0.0/26'
  }
  {
    name: 'snet-sharedservices-adds-001'
    prefix: '10.16.0.64/26'
  }      
]
//var Test_vNet_dnsServers = [
 // '192.168.10.10'
//]
var My_ResourceGroup = 'rg-${companyPrefix}-Network'
var My_vNetName = 'vnet-${companyPrefix}-001'
var My_vNet_Prefix = '10.17.0.0/16'
var My_vNet_Subnets = [
  {
    name: 'snet-001'
    prefix: '10.17.0.0/26'
  }
  {
    name: 'snet-002'
    prefix: '10.17.1.0/24'
  }
  {
    name: 'snet--003'
    prefix: '10.17.2.0/24'
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
     Subnets: My_vNet_Subnets
     Name: My_vNetName
     Prefix: My_vNet_Prefix
  }
  dependsOn: [
    TestvNet
  ]
  scope: resourceGroup(My_ResourceGroup)
}
 
module TestvNet './Template/vNet.bicep' = {
  name: 'Test-vNet-Deployment'
  params: {
    //dnsServers: vNet_dnsServers
     Location: Location
     Subnets: Test_vNet_Subnets
     Name: Test_vNet_Name
     Prefix: Test_vNet_Prefix
  }
  scope: resourceGroup(Test_ResourceGroup)
}



module MyPeering './Template/Peering.bicep' = {
  name: 'MyvNetPeering'
  params: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    remoteResourceGroup: 'rg-${companyPrefix}-network'
    remoteVirtualNetworkName: 'vnet-${companyPrefix}-001'
    useRemoteGateways: false
    virtualNetworkName: MyvNet.outputs.name
  }
  dependsOn: [
    MyvNet
  ]
  scope: resourceGroup(My_ResourceGroup)
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
    virtualNetworkName: TestvNet.outputs.name
  }
  dependsOn: [
    MyPeering
  ]
  scope: resourceGroup(Test_ResourceGroup)
}
