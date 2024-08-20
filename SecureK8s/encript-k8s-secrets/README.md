# Encrypting Kubernetes Secrets

In kubernetes, secrets are stored in base64 encoded format. This is not secure as anyone with access to the cluster can decode the secrets. To secure the secrets, we can encrypt them using the `kubeseal` tool.

In etcd (Kubernetes datastore), secrets are stored in plain text. To secure the secrets, we can encrypt them using the encription configuration in the kubernetes cluster.

In this guide we will take a look at how to encript secret using Kubernets enctyption resources.

## Prerequisites

- A Kubernetes cluster minikube cluster
- kubectl installed
- Minimum Kubernetes version 1.26

## Step 1 - Create a cluster with Minikube

Create a cluster with minikube using the following command:

```bash
minikube start --nodes 3 -p encript-k8s-secrets
```

## Step 2 - Create a secret

Create a secret in the cluster using the following command:

```bash
kubectl create secret generic my-secret --from-literal=username=admin --from-literal=password=passw0rd
```

## View the secret in the cluster etcd store

To view the secerts in the cluster etcd store, we need to access the etcd store. First we need to exec in to the minikube node and then access the etcd store.

```bash
docker exec -it encript-k8s-secrets bash
```

Then we need to find the required certificate location which use for authenticating the etcd store. Open a new terminal and run the following command:

```bash
kubectl describe pod -n kube-system <etcd-pod-name>
```

Example output:

```bash

Containers:
  etcd:
    Container ID:  docker://611f7309fcd560f6bc787ac75eeb102f01ee374c83e24f59e7e0b1c938d49080
    Image:         registry.k8s.io/etcd:3.5.12-0
    Image ID:      docker-pullable://registry.k8s.io/etcd@sha256:44a8e24dcbba3470ee1fee21d5e88d128c936e9b55d4bc51fbef8086f8ed123b
    Port:          <none>
    Host Port:     <none>
    Command:
      etcd
      --advertise-client-urls=https://192.168.85.2:2379
      --cert-file=/var/lib/minikube/certs/etcd/server.crt
      --client-cert-auth=true
      --data-dir=/var/lib/minikube/etcd
      --experimental-initial-corrupt-check=true
      --experimental-watch-progress-notify-interval=5s
      --initial-advertise-peer-urls=https://192.168.85.2:2380
      --initial-cluster=ckad-lab=https://192.168.85.2:2380
      --key-file=/var/lib/minikube/certs/etcd/server.key
      --listen-client-urls=https://127.0.0.1:2379,https://192.168.85.2:2379
      --listen-metrics-urls=http://127.0.0.1:2381
      --listen-peer-urls=https://192.168.85.2:2380
      --name=ckad-lab
      --peer-cert-file=/var/lib/minikube/certs/etcd/peer.crt
      --peer-client-cert-auth=true
      --peer-key-file=/var/lib/minikube/certs/etcd/peer.key
      --peer-trusted-ca-file=/var/lib/minikube/certs/etcd/ca.crt
      --proxy-refresh-interval=70000
      --snapshot-count=10000
      --trusted-ca-file=/var/lib/minikube/certs/etcd/ca.crt
    State:          Running
      Started:      Tue, 20 Aug 2024 18:54:49 +0200
```

From the above output, we can see the certificate location is `/var/lib/minikube/certs/etcd`. Make note of the location.


Now switch back to the minikube node terminal and we need to install the `etcdctl` tool to access the etcd store.

```bash
apt-get update
apt-get install etcd-client -y
apt-get install bsdmainutils -y # for hexdump
apt-get install vim -y
```

Now we can access the etcd store using the following command and replace the certificate location with the one we found earlier:

```bash
ETCDCTL_API=3 etcdctl \
   --cacert=/var/lib/minikube/certs/etcd/ca.crt   \
   --cert=/var/lib/minikube/certs/etcd/server.crt \
   --key=/var/lib/minikube/certs/etcd/server.key  \
   get /registry/secrets/default/my-secret | hexdump -C
```

Example output:

```bash
ETCDCTL_API=3 etcdctl \
   --cacert=/var/lib/minikube/certs/etcd/ca.crt   \
   --cert=/var/lib/minikube/certs/etcd/server.crt \
   --key=/var/lib/minikube/certs/etcd/server.key  \
   get /registry/secrets/default/my-secret | hexdump -C
00000000  2f 72 65 67 69 73 74 72  79 2f 73 65 63 72 65 74  |/registry/secret|
00000010  73 2f 64 65 66 61 75 6c  74 2f 6d 79 2d 73 65 63  |s/default/my-sec|
00000020  72 65 74 0a 6b 38 73 00  0a 0c 0a 02 76 31 12 06  |ret.k8s.....v1..|
00000030  53 65 63 72 65 74 12 f8  01 0a c4 01 0a 09 6d 79  |Secret........my|
00000040  2d 73 65 63 72 65 74 12  00 1a 07 64 65 66 61 75  |-secret....defau|
00000050  6c 74 22 00 2a 24 66 39  65 39 65 34 30 66 2d 39  |lt".*$f9e9e40f-9|
00000060  66 38 65 2d 34 33 66 30  2d 39 39 61 61 2d 62 32  |f8e-43f0-99aa-b2|
00000070  38 30 34 34 34 61 30 31  34 31 32 00 38 00 42 08  |80444a01412.8.B.|
00000080  08 de bf 93 b6 06 10 00  8a 01 75 0a 0e 6b 75 62  |..........u..kub|
00000090  65 63 74 6c 2d 63 72 65  61 74 65 12 06 55 70 64  |ectl-create..Upd|
000000a0  61 74 65 1a 02 76 31 22  08 08 de bf 93 b6 06 10  |ate..v1"........|
000000b0  00 32 08 46 69 65 6c 64  73 56 31 3a 41 0a 3f 7b  |.2.FieldsV1:A.?{|
000000c0  22 66 3a 64 61 74 61 22  3a 7b 22 2e 22 3a 7b 7d  |"f:data":{".":{}|
000000d0  2c 22 66 3a 70 61 73 73  77 6f 72 64 22 3a 7b 7d  |,"f:password":{}|
000000e0  2c 22 66 3a 75 73 65 72  6e 61 6d 65 22 3a 7b 7d  |,"f:username":{}|
000000f0  7d 2c 22 66 3a 74 79 70  65 22 3a 7b 7d 7d 42 00  |},"f:type":{}}B.|
00000100  12 14 0a 08 70 61 73 73  77 6f 72 64 12 08 70 61  |....password..pa|
00000110  73 73 77 30 72 64 12 11  0a 08 75 73 65 72 6e 61  |ssw0rd....userna|
00000120  6d 65 12 05 61 64 6d 69  6e 1a 06 4f 70 61 71 75  |me..admin..Opaqu|
00000130  65 1a 00 22 00 0a                                 |e.."..|
00000136
```

From the above output, we can see the secret is stored in plain text in the etcd store. To secure the secret, we can encrypt the secret using the kubernetes encryption resources.

## Step 3 - Encrypt the secret

To encrypt the secret, we need to create a encryption configuration in the cluster. Create a encryption configuration in the cluster using the following configuration:

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - aesgcm:
          keys:
            - name: key1
              secret: c2VjcmV0IGlzIHNlY3VyZQ==
            - name: key2
              secret: dGhpcyBpcyBwYXNzd29yZA==
      - identity: {}
```
For more information on the encryption configuration, refer to the [official documentation](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).


To create the encription we need to use the kube api server parameter `--encryption-provider-config` and pass the encryption configuration file. Therfore first we will add the encryption configuration to a file and then pass the file to the kube api server.

```bash
mkdir -p /etc/kubernetes/enc
vim /etc/kubernetes/enc/encrip-config.yaml
```

Then open the kube-api server configuration file and add the following parameter. In this we will add the encryption configuration file to the kube api server and use volume mount to pass the file to the kube api server.

```bash
vim /etc/kubernetes/manifests/kube-apiserver.yaml

--encryption-provider-config=/etc/kubernetes/enc/encrip-config.yaml

# volumeMounts
- name: enc                          
  mountPath: /etc/kubernetes/enc     
  readOnly: true 

# volumes
- name: enc                             
  hostPath:                            
    path: /etc/kubernetes/enc           
    type: DirectoryOrCreate
```

After the configurations added you can see the kube api server is restarted and the encryption configuration is added to the cluster.

## Step 4 - Create a secret

Create a secret in the cluster using the following command:

```bash
kubectl create secret generic my-secret2 --from-literal=username=admin --from-literal=password=passw0rd
```

## View the secret in the cluster etcd store

To view the secerts in the cluster etcd store, we need to access the etcd store. First we need to exec in to the minikube node and then access the etcd store.

```bash
ETCDCTL_API=3 etcdctl \
   --cacert=/var/lib/minikube/certs/etcd/ca.crt   \
   --cert=/var/lib/minikube/certs/etcd/server.crt \
   --key=/var/lib/minikube/certs/etcd/server.key  \
   get /registry/secrets/default/my-secret | hexdump -C
```

Abpve command will return the encrypted secret in the etcd store.