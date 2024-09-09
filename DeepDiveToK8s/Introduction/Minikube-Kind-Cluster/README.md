# Create Kubernetes Cluster for Playground

Easiest way to tryout Kubernetes is to create a cluster with Minikube or Kind.

## Minikube

Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a VM on your laptop for users looking to try out Kubernetes or develop with it day-to-day.

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [brew for MacOS](https://brew.sh/)

### Installation

For MacOS, you can install Minikube using brew.

```bash
brew install minikube
```

For other platforms, you can download the binary from the [official website](https://minikube.sigs.k8s.io/docs/start/).

### Start Minikube

If you want to setup the memory and cpu usage for Minikube, you can use the following command.

```bash	
minikube config set cpus 2
minikube config set memory 2048
```

```bash
minikube start
```

You can start multiple instances of Minikube with different profiles.

```bash
minikube start -p myprofile
```

You can create multi nodes cluster with Minikube.

```bash
minikube start --nodes 3 -p learn-k8s
```

Create a high availability cluster with 6 nodes. Need Minikube 1.32 or later.
To chose the network plugin, you can use the flag `--network-plugin`.
```bash
minikube start --ha --nodes 6 --network-plugin calico -p learn-k8s
minikube start --ha --nodes 6 -p learn-k8s # default network plugin is kindnet
```

### Access Minikube Dashboard

Minikube comes with a built-in dashboard that can be accessed using the following command. This will open the default Kubernetes dashboard in your default browser.

```bash
minikube dashboard
```

### Stop Minikube

```bash
minikube stop -p learn-k8s
```

### Delete Minikube

```bash
minikube delete -p learn-k8s
```

## Kind

Kind is a tool for running local Kubernetes clusters using Docker container “nodes”. Kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

### Prerequisites

Fllowing tools are required to create a Kind cluster.

- [Docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [brew for MacOS](https://brew.sh/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)


### Installation

For MacOS, you can install Kind using brew.

```bash
brew install kind
```

For other platforms, you can download the binary from the [official website](https://kind.sigs.k8s.io/docs/user/quick-start/).

### Create Kind Cluster

```bash
kind create cluster
```

You can create multi nodes cluster with Kind.

You can use kind configuration file to create a cluster with specific configuration.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```
For more configuration options, you can refer to the [official documentation](https://kind.sigs.k8s.io/docs/user/quick-start/).

```bash
kind create cluster --name learn-k8s --config kind-config.yaml
```

### Access Kind Cluster

```bash
kubectl cluster-info --context kind-kind
```

### Delete Kind Cluster

```bash
kind delete cluster --name learn-k8s
```

## Conclusion

Minikube and Kind are two popular tools to create Kubernetes clusters for local development. Minikube is a single-node/multi-node cluster that runs inside a VM on your laptop, while Kind is a tool for running local Kubernetes clusters using Docker container “nodes”. Both tools are easy to use and provide a great way to get started with Kubernetes.
