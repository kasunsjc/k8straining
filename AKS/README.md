## Azure Kubernetes Service (AKS)

## Overview

Azure Kubernetes Service (AKS) is a managed Kubernetes service that makes it easy to deploy and manage containerized applications without container orchestration expertise. AKS reduces the complexity and operational overhead of managing Kubernetes by offloading much of that responsibility to Azure. You can use AKS to deploy a production-ready Kubernetes cluster in just a few minutes.

## Prerequisites

* An Azure subscription with permissions to create new resources. See [Create an Azure account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) for details.
* The [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest&WT.mc_id=A261C142F) installed and configured.
* The [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command-line tool installed and configured.

## Create an AKS cluster

1. Create a resource group for your AKS cluster.

    ```bash
    az group create --name myResourceGroup --location eastus
    ```

2. Create an AKS cluster.

    ```bash
    az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 1 --enable-addons monitoring --generate-ssh-keys
    ```

3. Connect to the cluster.

    ```bash
    az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
    ```

4. Verify the connection to the cluster.

    ```bash
    kubectl get nodes
    ```

## Deploy an application to the cluster

1. Deploy the application.

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/azure-voting-app-redis/master/azure-vote-all-in-one-redis.yaml
    ```

2. View the application.

    ```bash
    kubectl get service azure-vote-front --watch
    ```

    > Note: The `--watch` flag is optional, but it allows you to view the status of the service as it is being provisioned.

3. Clean up resources.

    ```bash
    kubectl delete -f https://raw.githubusercontent.com/Azure-Samples/azure-voting-app-redis/master/azure-vote-all-in-one-redis.yaml
    ```

## Next steps

* [Azure Kubernetes Service documentation](https://docs.microsoft.com/azure/aks/?WT.mc_id=A261C142F)