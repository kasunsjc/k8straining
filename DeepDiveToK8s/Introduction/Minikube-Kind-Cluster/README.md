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
minikube config set cpus 1
minikube config set memory 1024
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

When using minikube you can use the following command to see the procsess running.

```bash
docker exec <container-name> ps -aux | grep -i kube # Filter kubernetes processes
```
Following is an example of the output of the above command.

```bash
root        1380  2.4  1.7 2655044 72088 ?       Ssl  18:11   2:16 /var/lib/minikube/binaries/v1.30.0/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --config=/var/lib/kubelet/config.yaml --hostname-override=learn-helm --kubeconfig=/etc/kubernetes/kubelet.conf --node-ip=192.168.85.2

root        1818  1.3  2.2 1331964 91332 ?       Ssl  18:11   1:12 kube-controller-manager --allocate-node-cidrs=true --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf --bind-address=127.0.0.1 --client-ca-file=/var/lib/minikube/certs/ca.crt --cluster-cidr=10.244.0.0/16 --cluster-name=mk --cluster-signing-cert-file=/var/lib/minikube/certs/ca.crt --cluster-signing-key-file=/var/lib/minikube/certs/ca.key --controllers=*,bootstrapsigner,tokencleaner --kubeconfig=/etc/kubernetes/controller-manager.conf --leader-elect=false --requestheader-client-ca-file=/var/lib/minikube/certs/front-proxy-ca.crt --root-ca-file=/var/lib/minikube/certs/ca.crt --service-account-private-key-file=/var/lib/minikube/certs/sa.key --service-cluster-ip-range=10.96.0.0/12 --use-service-account-credentials=true

root        1821  0.2  0.9 1285392 38432 ?       Ssl  18:11   0:15 kube-scheduler --authentication-kubeconfig=/etc/kubernetes/scheduler.conf --authorization-kubeconfig=/etc/kubernetes/scheduler.conf --bind-address=127.0.0.1 --kubeconfig=/etc/kubernetes/scheduler.conf --leader-elect=false

root        1822  2.4  1.6 11222952 66020 ?      Ssl  18:11   2:13 etcd --advertise-client-urls=https://192.168.85.2:2379 --cert-file=/var/lib/minikube/certs/etcd/server.crt --client-cert-auth=true --data-dir=/var/lib/minikube/etcd --experimental-initial-corrupt-check=true --experimental-watch-progress-notify-interval=5s --initial-advertise-peer-urls=https://192.168.85.2:2380 --initial-cluster=learn-helm=https://192.168.85.2:2380 --key-file=/var/lib/minikube/certs/etcd/server.key --listen-client-urls=https://127.0.0.1:2379,https://192.168.85.2:2379 --listen-metrics-urls=http://127.0.0.1:2381 --listen-peer-urls=https://192.168.85.2:2380 --name=learn-helm --peer-cert-file=/var/lib/minikube/certs/etcd/peer.crt --peer-client-cert-auth=true --peer-key-file=/var/lib/minikube/certs/etcd/peer.key --peer-trusted-ca-file=/var/lib/minikube/certs/etcd/ca.crt --proxy-refresh-interval=70000 --snapshot-count=10000 --trusted-ca-file=/var/lib/minikube/certs/etcd/ca.crt

root        1843  5.7  6.8 1539668 274020 ?      Ssl  18:11   5:17 kube-apiserver --advertise-address=192.168.85.2 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/var/lib/minikube/certs/ca.crt --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota --enable-bootstrap-token-auth=true --etcd-cafile=/var/lib/minikube/certs/etcd/ca.crt --etcd-certfile=/var/lib/minikube/certs/apiserver-etcd-client.crt --etcd-keyfile=/var/lib/minikube/certs/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --kubelet-client-certificate=/var/lib/minikube/certs/apiserver-kubelet-client.crt --kubelet-client-key=/var/lib/minikube/certs/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/var/lib/minikube/certs/front-proxy-client.crt --proxy-client-key-file=/var/lib/minikube/certs/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/var/lib/minikube/certs/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=8443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/var/lib/minikube/certs/sa.pub --service-account-signing-key-file=/var/lib/minikube/certs/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/var/lib/minikube/certs/apiserver.crt --tls-private-key-file=/var/lib/minikube/certs/apiserver.key

root        2591  0.0  0.8 1284004 32200 ?       Ssl  18:12   0:00 /usr/local/bin/kube-proxy --config=/var/lib/kube-proxy/config.conf --hostname-override=learn-helm

999         3646  0.0  0.6 1275944 26956 ?       Ssl  18:12   0:01 /usr/bin/kube-controllers
```

## Conclusion

Minikube and Kind are two popular tools to create Kubernetes clusters for local development. Minikube is a single-node cluster that runs inside a VM on your laptop, while Kind is a tool for running local Kubernetes clusters using Docker container “nodes”. Both tools are easy to use and provide a great way to get started with Kubernetes.
