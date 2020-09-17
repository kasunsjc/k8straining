kubectl exec pod-with-host-network ifconfig

kubectl exec pod-with-host-pid-and-ipc ps aux

#Pod Security Policies
kubectl run pod-with-defaults --image alpine --restart Never -- /bin/sleep 999999

#Default Pod for testing Security 
kubectl exec pod-with-defaults id

#Running Container as specific user 
kubectl get po pod-run-as-non-root

#Run container as privilaged user
kubectl exec -it pod-privileged ls /dev