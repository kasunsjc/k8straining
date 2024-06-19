#Create deployment with record enabled
kubectl create -f kubia-deployment-v1.yaml --record

#Get Deployment status
kubectl rollout status deployment kubia

# Get pods
kubectl get pod

# Get Replicasets
kubectl get replicasets

while true; do curl http://20.43.159.226; done

#Changet the Image to see the rolling update
kubectl set image deployment kubia nodejs=kasunsjc/kubia:v2


# Demo Roleback update
kubectl set image deployment kubia nodejs=kasunsjc/kubia:v3 #bug in the image

kubectl rollout undo deployment kubia   

#-------------------------- Control update with Update Strategy-------------------

#Create deployment with record enabled
kubectl create -f kubia-deployment-rollingupdate.yaml --record

while true; do curl http://130.211.109.222; done

kubectl set image deployment kubia nodejs=kasunsjc/kubia:v2