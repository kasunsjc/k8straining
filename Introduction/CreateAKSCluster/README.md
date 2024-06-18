# Creating an Azure AKS Cluster

This guide will walk you through the steps to create an Azure AKS (Azure Kubernetes Service) cluster using both the Azure CLI and PowerShell.

## Prerequisites

Before you begin, make sure you have the following:

- An Azure subscription
- Azure CLI installed (version 2.0.80 or later)
- PowerShell installed (version 7.0 or later)

## Step 1: Azure CLI

1. Open a terminal or command prompt.
2. Log in to your Azure account using the following command:
  ```
  az login
  ```
3. If you have multiple subscriptions, set the desired subscription using the following command:
  ```
  az account set --subscription <subscription_id>
  ```
4. Create a resource group for your AKS cluster:
  ```
  az group create --name <resource_group_name> --location <location>
  ```
5. Create the AKS cluster:
  ```
  az aks create --resource-group <resource_group_name> --name <cluster_name> --node-count <node_count> --node-vm-size <vm_size> --generate-ssh-keys
  ```

## Step 2: PowerShell

1. Open PowerShell.
2. Log in to your Azure account using the following command:
  ```
  Connect-AzAccount
  ```
3. If you have multiple subscriptions, set the desired subscription using the following command:
  ```
  Set-AzContext -SubscriptionId <subscription_id>
  ```
4. Create a resource group for your AKS cluster:
  ```
  New-AzResourceGroup -Name <resource_group_name> -Location <location>
  ```
5. Create the AKS cluster:
  ```
  New-AzAksCluster -ResourceGroupName <resource_group_name> -Name <cluster_name> -NodeCount <node_count> -NodeVmSize <vm_size> -GenerateSshKey
  ```

That's it! You have successfully created an Azure AKS cluster using both the Azure CLI and PowerShell.

## Step 3: Azure Bicep
1. Create a new file called `main.bicep` in the same folder as your `README.md` file.
2. Add the following code to the `main.bicep` file to define the AKS cluster resources:
3. Save the `main.bicep` file.
4. Deploy the AKS cluster using Azure Bicep by running the following command in the terminal or command prompt:
```bash
az deployment group create --resource-group <resource_group_name> --template-file main.bicep
```
5. Wait for the deployment to complete. Once it's done, you will have your AKS cluster up and running.

That's it! You have successfully created an Azure AKS cluster using Azure Bicep.

