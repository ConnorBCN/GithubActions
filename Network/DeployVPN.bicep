module virtualNetworkGateway './Template/VirtualNetworkGateway.bicep' = {
  name: 'VirtualNetworkGateway'
  params: {
    enableBGP: false
    gatewayType: 'Vpn'
    location: resourceGroup().location
    PublicIpAddressName: 'pip-vng-sharedservices-001'
    rgName: resourceGroup().name 
    sku: 'Basic'
    SubnetName: 'GatewaySubnet'
    virtualNetworkGatewayName: 'vng-sharedservices-001'
    VirtualNetworkName: 'vnet-bicep-sharedservices-001'
    vpnType: 'RouteBased'
  }
}
module localNetworkGateway './Template/LocalNetworkGateway.bicep' = {
  name: 'LocalNetworkGateway'
  params: {
    addressPrefixes: [
      '192.168.1.0/24'
      '192.168.10.0/24'
    ]
    gatewayIpAddress: '80.80.80.80'
    localNetworkGatewayName: 'lng-MyLocalGateway-001'
    location: resourceGroup().location
  }
}
 
module connection './Template/Connection.bicep' = {
  name: 'connection'
  params: {
    connectionName: 'cnt-Myconnection'
    connectionType: 'IPSec'
    enableBgp: false
    localNetworkGatewayId: localNetworkGateway.outputs.lngid
    location: resourceGroup().location
    sharedKey: '93hg87ghf834bf874bf834hf8bf3uir3fb38'
    virtualNetworkGatewayId: virtualNetworkGateway.outputs.vngid
  }
}
