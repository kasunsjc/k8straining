# Kuberneters Architecture Explained

Kubernetes is a container orchestration platform that automates the deployment, scaling, and management of containerized applications. It is an open-source platform that was originally developed by Google and is now maintained by the Cloud Native Computing Foundation (CNCF). Kubernetes is designed to be extensible and scalable, allowing you to run applications in containers across a cluster of machines.

In this guide, we will explore the architecture of Kubernetes and how it works.

## Components of Kubernetes

Kubernetes is made up of several components that work together to manage your containerized applications. These components include:

- **Control Node**: The control node is responsible for managing the cluster and its components. It includes several components such as the API server, scheduler, and controller manager.
- **Worker Node**: The worker node is responsible for running your containerized applications. It includes components such as the kubelet and kube-proxy.

### Control Node Components

The master node includes the following components:

- **API Server**: The API server is the central management point for the Kubernetes cluster. It exposes the Kubernetes API, which allows you to interact with the cluster.
- **Scheduler**: The scheduler is responsible for scheduling pods (groups of containers) to run on the worker nodes.
- **Controller Manager**: The controller manager is responsible for managing the various controllers that regulate the state of the cluster.
- **etcd**: etcd is a distributed key-value store that is used to store the cluster's configuration data.
- **Cloud Controller Manager**: The cloud controller manager is responsible for interacting with the underlying cloud provider to manage resources such as load balancers and volumes.
- **Add-ons**: Add-ons are optional components that provide additional functionality to the cluster, such as the DNS service and the dashboard.
  
### Worker Node Components

- **Kubelet**: The kubelet is an agent that runs on each worker node and is responsible for managing the containers on that node.
- **Kube-proxy**: The kube-proxy is responsible for managing network connectivity between pods and services.
- **Container Runtime**: The container runtime is responsible for running the containers on the worker nodes. Kubernetes supports several container runtimes, including Docker and containerd.
  
## Dive in to Control Plane Components

Before we see the components in action, we need to have a working Kubernetes cluster. You can set up a Kubernetes cluster using tools like Minikube, kubeadm, or kops. Refer [here](../Introduction/Minikube-Kind-Cluster/README.md)

In Minikube cluster control plane components are running as static pods in kube-system namespace. You can see them by running below command:

```bash
kubectl get pods -n kube-system
```

Lets first explore API Server, Scheduler and Controller Manager.

### API Server Scheduler, etcd, and Controller Manager

We can see the control plane components in the control node as below:

List all the nodes in the cluster:

```bash
kubectl get nodes
```

Output will be like below:

```bash
NAME            STATUS   ROLES           AGE     VERSION
learn-k8s       Ready    control-plane   2m55s   v1.30.0
learn-k8s-m02   Ready    control-plane   2m16s   v1.30.0
learn-k8s-m03   Ready    control-plane   103s    v1.30.0
learn-k8s-m04   Ready    <none>          69s     v1.30.0
learn-k8s-m05   Ready    <none>          40s     v1.30.0
learn-k8s-m06   Ready    <none>          12s     v1.30.0
```

Exec into the control node:

```bash
docker exec -it <NodeName> bash
```

Change directory to the kubernetes folder that contains the configuration files for the cluster components. The default location is `/etc/kubernetes/`:

```bash
cd /etc/kubernetes/
```
You can find the Pod manifest file for the API server in the `manifests` directory:

```bash
ls manifests
```

For example the API server manifest file will be like below:

```bash
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 192.168.49.2:8443
  creationTimestamp: null
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=192.168.49.2
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/var/lib/minikube/certs/ca.crt
    - --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota
    - --enable-bootstrap-token-auth=true
    - --etcd-cafile=/var/lib/minikube/certs/etcd/ca.crt
    - --etcd-certfile=/var/lib/minikube/certs/apiserver-etcd-client.crt
    - --etcd-keyfile=/var/lib/minikube/certs/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
    - --kubelet-client-certificate=/var/lib/minikube/certs/apiserver-kubelet-client.crt
    - --kubelet-client-key=/var/lib/minikube/certs/apiserver-kubelet-client.key
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --proxy-client-cert-file=/var/lib/minikube/certs/front-proxy-client.crt
    - --proxy-client-key-file=/var/lib/minikube/certs/front-proxy-client.key
    - --requestheader-allowed-names=front-proxy-client
    - --requestheader-client-ca-file=/var/lib/minikube/certs/front-proxy-ca.crt
    - --requestheader-extra-headers-prefix=X-Remote-Extra-
    - --requestheader-group-headers=X-Remote-Group
    - --requestheader-username-headers=X-Remote-User
    - --secure-port=8443
    - --service-account-issuer=https://kubernetes.default.svc.cluster.local
    - --service-account-key-file=/var/lib/minikube/certs/sa.pub
    - --service-account-signing-key-file=/var/lib/minikube/certs/sa.key
    - --service-cluster-ip-range=10.96.0.0/12
    - --tls-cert-file=/var/lib/minikube/certs/apiserver.crt
    - --tls-private-key-file=/var/lib/minikube/certs/apiserver.key
    image: registry.k8s.io/kube-apiserver:v1.30.0
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 192.168.49.2
        path: /livez
        port: 8443
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: kube-apiserver
    readinessProbe:
      failureThreshold: 3
      httpGet:
        host: 192.168.49.2
        path: /readyz
        port: 8443
        scheme: HTTPS
      periodSeconds: 1
      timeoutSeconds: 15
    resources:
      requests:
        cpu: 250m
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 192.168.49.2
        path: /livez
        port: 8443
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /etc/ssl/certs
      name: ca-certs
      readOnly: true
    - mountPath: /etc/ca-certificates
      name: etc-ca-certificates
      readOnly: true
    - mountPath: /var/lib/minikube/certs
      name: k8s-certs
      readOnly: true
    - mountPath: /usr/local/share/ca-certificates
      name: usr-local-share-ca-certificates
      readOnly: true
    - mountPath: /usr/share/ca-certificates
      name: usr-share-ca-certificates
      readOnly: true
  hostNetwork: true
  priority: 2000001000
  priorityClassName: system-node-critical
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  volumes:
  - hostPath:
      path: /etc/ssl/certs
      type: DirectoryOrCreate
    name: ca-certs
  - hostPath:
      path: /etc/ca-certificates
      type: DirectoryOrCreate
    name: etc-ca-certificates
  - hostPath:
      path: /var/lib/minikube/certs
      type: DirectoryOrCreate
    name: k8s-certs
  - hostPath:
      path: /usr/local/share/ca-certificates
      type: DirectoryOrCreate
    name: usr-local-share-ca-certificates
  - hostPath:
      path: /usr/share/ca-certificates
      type: DirectoryOrCreate
    name: usr-share-ca-certificates
status: {}
```

## Dive in to Worker Node Components

Worker node components are such as Kubelet, Kube-proxy, and Container Runtime. kube-proxy is a network proxy that runs on each worker node and is responsible for managing network connectivity between pods and services. The kubelet is an agent that runs on each worker node and is responsible for managing the containers on that node. The container runtime is responsible for running the containers on the worker nodes. Kubernetes supports several container runtimes, including Docker and containerd.


### Kubelet

We can view the kubelet configuration file by running the below command:

```bash
# Login to the worker node/control node

docker exec -it <NodeName> bash

systemctl status kubelet  # can see the kubelet service status
```
You can find the similar output as below:

```bash
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; disabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Thu 2024-07-04 21:11:54 UTC; 4min 50s ago
       Docs: http://kubernetes.io/docs/
   Main PID: 2314 (kubelet)
      Tasks: 19 (limit: 4700)
     Memory: 63.0M
        CPU: 15.352s
     CGroup: /system.slice/kubelet.service
             └─2314 /var/lib/minikube/binaries/v1.30.0/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --config=/var/lib/kubelet/config.yaml --hostname-override=k8-lab --kubeconfig=/etc/kubernetes/kubelet.conf --node-ip=192.168.85.2
```

### Kube-proxy

kube-proxy is a network proxy that runs on each worker node and is responsible for managing network connectivity between pods and services. You can view the kube-proxy configuration file by running the below command:

```bash
k exec -it -n kube-system kube-proxy-748hp cat /var/lib/kube-proxy/config.conf
```