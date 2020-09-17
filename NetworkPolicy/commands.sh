kubectl create namespace development
kubectl label namespace/development purpose=development

#Create nginx deployment
kubectl run backend --image=nginx --labels app=webapp,role=backend --namespace development --expose --port 80

kubectl run --rm -it --image=alpine network-policy --namespace development

wget -qO- http://backend

# Apply Network Policy
kubectl apply -f backend-policy.yaml

kubectl run --rm -it --image=alpine network-policy --namespace development

wget -qO- --timeout=2 http://backend

# Apply Pod Namespace Selector 

kubectl delete -f backend-policy.yaml

kubectl apply -f allow-backend-pod.yaml

kubectl run --rm -it frontend --image=alpine --labels app=webapp,role=frontend --namespace development

wget -qO- http://backend

# Allow traffic only from within define namespace 
kubectl create namespace production
kubectl label namespace/production purpose=production

kubectl run --rm -it frontend --image=alpine --labels app=webapp,role=frontend --namespace production

wget -qO- http://backend.development

# Apply namespace policy

kubectl delete -f allow-backend-pod.yaml

kubectl apply -f namespace-policy.yaml

kubectl run --rm -it frontend --image=alpine --labels app=webapp,role=frontend --namespace production

kubectl run --rm -it frontend --image=alpine --labels app=webapp,role=frontend --namespace development

wget -qO- http://backend


