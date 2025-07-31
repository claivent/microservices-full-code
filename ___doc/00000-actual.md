kubectl config set-context --current --namespace=kia  
minikube start --memory='4096' cpus='2' --force  


wsl --export tutorials C:\_M\wsl\luksa\minikube-k8s-installed\001-minikube-k8s-instaled.tar  






kubectl create -f 'https://strimzi.io/install/latest?namespace=dev' 


## Argo cd
kubectl run curl --image=alpine/curl:8.2.1 -n kube-system -i --tty --rm -- sh

kubectl exec -it -n kube-system curl -- sh

for i in `seq 1 1000`; do curl myapp.default:8181/version; echo ""; sleep 1; done


kubectl rollout --help

ARGO CD


watch -n 0.5 -t "kubectl get pods -n default -o custom-columns='NAME:.metadata.name,IMAGE:.spec.containers[*].image' | grep myapp"


watch -n 0.5 -t "kubectl get pods -n default -o custom-columns='NAME:.metadata.name,READY:.status.containerStatuses[*].ready,STATUS:.status.phase,RESTARTS:.status.containerStatuses[*].restartCount,IMAGE:.spec.containers[*].image,AGE:.metadata.creationTimestamp' | grep myapp"





for i in `seq 1 1000`; do curl hello-world-rolling.default:8080/version; echo ""; sleep 1; done

watch -n 0.5 -t "kubectl get pods -n default -o custom-columns='NAME:.metadata.name,IMAGE:.spec.containers[*].image' | grep hello-world-rolling"

watch -n 0.5 -t "kubectl get pods -n default -o custom-columns='NAME:.metadata.name,READY:.status.containerStatuses[*].ready,STATUS:.status.phase,RESTARTS:.status.containerStatuses[*].restartCount,IMAGE:.spec.containers[*].image,AGE:.metadata.creationTimestamp' | grep hello-world-rolling"



kubectl annotate deployment hello-world-rolling kubernetes.io/change-cause="Rollout na verzi 2.0"
kubectl rollout undo deployment hello-world-rolling --to-revision=13



kubectl patch deployment hello-world-rolling \
-p '{"spec": {"revisionHistoryLimit": 2}}'
                                        
### konec Argo
