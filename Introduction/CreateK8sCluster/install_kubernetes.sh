#! /bin/bash
# run on master node

# Download the CNI provider 
wget https://docs.projectcalico.org/manifests/calico.yaml

# verify the IP Range search for CALICO_IPV4POOL_CIDR
less calico.yaml

# Add nodes ip address to the hosts workers and master
# example 10.128.0.3 k8smaster
vim /etc/hosts

# Create kubeadm config file 
vim kubeadm-config.yaml

# Run kubeadm
kubeadm init --config=kubeadm-config.yaml --upload-certs \
| tee kubeadm-init.out

# logout to standard user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
less .kube/config

#Install network plugin
sudo cp /root/calico.yaml
kubectl apply -f calico.yaml

#Enable bash completion
sudo apt-get install bash-completion -y
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
