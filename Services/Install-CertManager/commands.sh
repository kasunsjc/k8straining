#----------------------Install Ingress-------------------------------------------------
$PublicIP = az network public-ip create --resource-group MC_kube-demo-aks_kubeaksdemo_southeastasia --name aksingress-pip --sku Standard --allocation-method static --query publicIp.ipAddress -o tsv

kubectl create namespace ingress-basic

helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm install nginx-ingress stable/nginx-ingress `
    --namespace ingress-basic `
    --set controller.replicaCount=2 `
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux `
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux `
    --set controller.service.loadBalancerIP="20.44.197.235" `
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="kasunaksdemo"


#--------------------------------Install Cert-Manger------------------------------

# Install the CustomResourceDefinition resources separately
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.13/deploy/manifests/00-crds.yaml

# Label the cert-manager namespace to disable resource validation
kubectl label namespace ingress-basic cert-manager.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install `
  cert-manager `
  --namespace ingress-basic `
  --version v0.13.0 `
  jetstack/cert-manager