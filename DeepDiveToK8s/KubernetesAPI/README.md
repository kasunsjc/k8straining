# Kubernetes API

The Kubernetes API (Application Programming Interface) is a powerful tool that allows developers to interact with and manage Kubernetes clusters programmatically. It provides a set of endpoints that can be accessed to perform various operations on the cluster.

## API Groups

The Kubernetes API is organized into different API groups, each serving a specific purpose. Here are some commonly used API groups:

- **Core API Group**: This group contains the fundamental resources and operations of Kubernetes, such as Pods, Services, and Deployments. It is accessed using the `/api/v1` endpoint.

- **Apps API Group**: This group focuses on higher-level abstractions for deploying and managing applications on Kubernetes. It includes resources like ReplicaSets, StatefulSets, and DaemonSets. It is accessed using the `/apis/apps/v1` endpoint.

- **Batch API Group**: This group is used for managing batch jobs and cron jobs in Kubernetes. It includes resources like Jobs and CronJobs. It is accessed using the `/apis/batch/v1` endpoint.

- **Extensions API Group**: This group provides additional extensions and custom resources for Kubernetes. It includes resources like Ingress, NetworkPolicies, and CustomResourceDefinitions. It is accessed using the `/apis/extensions/v1beta1` endpoint.

## Using the Kubernetes API

The Kubernetes API can be accessed using various programming languages and tools. Here are a few common ways to interact with the API:

- **kubectl**: The `kubectl` command-line tool is the most popular way to interact with the Kubernetes API. It provides a simple and intuitive interface for managing Kubernetes resources.

- **Client Libraries**: Kubernetes provides client libraries for different programming languages, such as Python, Go, Java, and JavaScript. These libraries abstract the API calls and provide a more convenient way to interact with the API programmatically.

- **Custom Applications**: Developers can also build custom applications that directly interact with the Kubernetes API. This allows for more flexibility and customization in managing Kubernetes resources.

Remember to authenticate and authorize your API requests to ensure the security of your Kubernetes cluster.

## Accessing Kubernetes API Endpoints

To access the Kubernetes API endpoints, you need to know the URL of the API server and the API path for the desired resource. For example, to list all Pods in the default namespace, you can use the following API endpoint:

```
GET /api/v1/namespaces/default/pods
```

Lets setup demo environment to interact with Kubernetes API using minikube. We will use `kubectl` and `curl` to interact with Kubernetes API.

### Setup Minikube

1. Start Minikube:

   ```bash
   minikube config set memory 2048
   minikube start --nodes 3 -p k8s-api
   ```	

2. Verify the status of the Minikube cluster:

   ```bash
    kubectl get nodes
    ```

3. Deploy a sample application:

   ```bash
   kubectl create deployment nginx --image=nginx
   ```

To access the API server we need to have the proper authentication and authorization. We can use `kubectl proxy` to access the API server. Kubectl will create a proxy server on your local machine and forward the requests to the API server.

This will open a proxy server on `localhost:8001` which will forward the requests to the API server.

```bash
kubectl proxy
```

Next we can use `curl` to interact with the API server. For example, to list all Pods in the default namespace, you can use the following command:

```bash
curl http://localhost:8001/api/v1/namespaces/default/pods
```

To list a specific Pod, you can use the following command:

```bash
curl http://localhost:8001/api/v1/namespaces/default/pods/<pod-name>
```
To list a specific service you can use the following command:

```bash
curl http://localhost:8001/api/v1/namespaces/default/services/<service-name>
```

For more information you can refer the [official documentation](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.31/). Note that the API version may vary based on the Kubernetes version you are using.

## Conclusion

The Kubernetes API is a powerful tool that allows developers to interact with and manage Kubernetes clusters programmatically. By understanding the API groups, accessing the API endpoints, and using the available tools, you can effectively manage your Kubernetes resources and applications.

