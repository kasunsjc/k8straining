#Create Service Accounts
kubectl create serviceaccount foo

#Describe SA
kubectl describe sa foo

#Describe the Secret of the SA
kubectl describe secret <SecretName>

#Get the Secret in the Pod file path 
kubectl exec -it curl-custom-sa -c main cat /var/run/secrets/kubernetes.io/serviceaccount/token

#Talking to the API Server
kubectl exec -it curl-custom-sa -c main curl localhost:8001/api/v1/pods