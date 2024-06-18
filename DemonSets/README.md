# Kubernetes DemonSets

DemonSets are a type of workload in Kubernetes that ensures a single pod is running on each node in the cluster. This is useful for scenarios where you need to run a daemon process on every node, such as log collectors, monitoring agents, or network proxies.

## How to Use DemonSets

To create a DemonSet, you can use the following YAML definition:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-demonset
spec:
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image:latest
```

This YAML definition creates a DemonSet named `my-demonset` with a single container running `my-image:latest`. The `selector` field ensures that the pod is scheduled on every node that has a label `app: my-app`.

To apply the DemonSet, use the following `kubectl` command:

```bash
kubectl apply -f my-demonset.yaml
```

To check the status of the DemonSet, you can use the following command:

```bash
kubectl get daemonset my-demonset
```

This will show you the number of desired, current, and ready pods in the DemonSet.

To delete the DemonSet, use the following command:

```bash
kubectl delete daemonset my-demonset
```

This will remove the DemonSet and all associated pods from the cluster.

For more information on DemonSets, refer to the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).
