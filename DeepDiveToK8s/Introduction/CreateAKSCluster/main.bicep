/* This is a simple example of how to create an AKS cluster with a VNet and a subnet using Bicep

For this we need to create a Resource Group, use following command to create a resource group

az group create --name demo-aks-rg --location northeurope

*/

param location string = 'northeurope'
param clusterName string = 'demo-aks-cluster'
param nodeCount int = 1
param vmSize string = 'Standard_D2_v2'


resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'sample-aks-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: '${vnet.name}/default'
  properties: {
    addressPrefix: '10.0.0.0/24'
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}

resource aks 'Microsoft.ContainerService/managedClusters@2021-07-01' = {
  name: clusterName
  location: location
  properties: {
    kubernetesVersion: '1.21.2'
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'default'
        count: nodeCount
        vmSize: vmSize
        osDiskSizeGB: 30
        osType: 'Linux'
        mode: 'System'
        enableAutoScaling: false
      }
    ]
    servicePrincipalProfile: {
      clientId: '<service_principal_client_id>'
      secret: '<service_principal_secret>'
    }
    networkProfile: {
      networkPlugin: 'azure'
      dnsServiceIp: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
      }
    }
    enableRBAC: true
    enablePodSecurityPolicy: false
  }
}
