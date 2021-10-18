#create resource group

az login

az account set --subscription "Azure-Subscription-ID"

az group create --name <Resource-Group-Name> --location <location>

az aks create --resource-group <Resource-Group-Name> --name <ClusterName> --node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks get-credentials --resource-group <Resource-Group-Name> --name <Cluster-Name>

# delete cluster

az group delete --name <Cluster-Name> --yes --no-wait