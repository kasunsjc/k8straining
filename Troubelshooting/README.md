# Kubernetes Troubleshooting

This document is a collection of tips and tricks for troubleshooting Kubernetes.

Follow the instructions in the [Troubleshooting Guide](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/) to troubleshoot your Kubernetes cluster.

Following commands are useful for troubleshooting Kubernetes.

## Troubleshooting Kubernetes

### Troubleshooting with `kubectl`

#### Get the version of the client and server

```shell
kubectl version
```

#### Describe a Node

`kubectl describe node` provides a detailed description of a node.

```shell
kubectl describe nodes <node-name>
```

#### Describe a Pod

`kubectl describe pod` provides a detailed description of a pod.

```shell
kubectl describe pods <pod-name>
```

#### Describe a Service

`kubectl describe service` provides a detailed description of a service.

```shell
kubectl describe services <service-name>
```

#### Get the events in the cluster

`kubectl get events` provides a list of events in the cluster.

```shell
kubectl get events
```

#### Get the logs from a container in a pod

`kubectl logs` provides the logs from a container in a pod.

```shell
kubectl logs <pod-name> <container-name>
```

#### Get the YAML manifest used to create a resource

`kubectl get -o yaml` provides the YAML manifest used to create a resource.

```shell
kubectl get <resource-type> <resource-name> -o yaml
```

#### Get the YAML manifest for all the resources

`kubectl get -o yaml --export` provides the YAML manifest for all the resources.

```shell
kubectl get <resource-type> -o yaml --export
```

#### Get the logs from all the containers in a pod

`kubectl logs` provides the logs from all the containers in a pod.

```shell
kubectl logs <pod-name> --all-containers
```

#### Get the logs from the previous instantiation of a container

`kubectl logs` provides the logs from the previous instantiation of a container.

```shell
kubectl logs -p <pod-name> <container-name>
```

#### Get the IP address of the pod

`kubectl get pod -o wide` provides the IP address of the pod.

```shell
kubectl get pod <pod-name> -o wide
```

#### Get the service endpoints

`kubectl get endpoints` provides the service endpoints.

```shell
kubectl get endpoints <service-name>
```

#### Exec a command in a container

`kubectl exec` runs a command in a container.

```shell
kubectl exec <pod-name> -c <container-name> -- <command>
```

#### Run a command in a new container

`kubectl run` runs a command in a new container.

```shell
kubectl run <container-name> --image=<image-name> -- <command>
```

#### Port forward

`kubectl port-forward` forwards one or more local ports to a pod.

```shell
kubectl port-forward <pod-name> <local-port>:<container-port>
```

#### Proxy

`kubectl proxy` runs a proxy to the Kubernetes API server.

```shell
kubectl proxy
```

#### Run a command in a pod

`kubectl run` runs a command in a pod.

```shell
kubectl run <pod-name> --image=<image-name> -- <command>
```