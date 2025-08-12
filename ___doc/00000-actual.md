kubectl config set-context --current --namespace=kia  
minikube start --memory='4096' cpus='2' --force  


wsl --export tutorials C:\_M\wsl\luksa\minikube-k8s-installed\001-minikube-k8s-instaled.tar  

testovací pod  
kubectl run curlpod --rm -i --tty --image=curlimages/curl -- sh  
http://discovery-service.default.svc.cluster.local:8761/actuator/info

kubectl delete -f config-server/ ; kubectl delete -f discovery/;  kubectl delete -f product/  
kubectl apply -f config-server/ ; kubectl apply -f discovery/;  kubectl apply -f product/  

wsl --cd C:\_M\java\heroku\microservices-full-code


kubectl rollout restart -n default deployment discovery-service
kubectl rollout restart -n default deployment payment-service
kubectl rollout restart -n default deployment product-service
kubectl rollout restart -n default deployment order-service
kubectl rollout restart -n default deployment customer-service
kubectl rollout restart -n default deployment notification-service
kubectl rollout restart -n default deployment gateway-service

kubectl apply -f ~/IdeaProjects/microservices-full-code/services/config-server/
kubectl apply -f ~/IdeaProjects/microservices-full-code/services/discovery/

kubectl apply -f ~/IdeaProjects/microservices-full-code/services/config-server/
kubectl apply -f ~/IdeaProjects/microservices-full-code/services/customer/
kubectl apply -f ~/IdeaProjects/microservices-full-code/services/gateway/
kubectl apply -f ~/IdeaProjects/microservices-full-code/services/notification/
kubectl apply -f ~/IdeaProjects/microservices-full-code/services/order/
kubectl apply -f ~/IdeaProjects/microservices-full-code/services/payment/
kubectl apply -f ~/IdeaProjects/microservices-full-code/services/product/

kubectl delete -f ~/IdeaProjects/microservices-full-code/services/config-server/
kubectl delete -f ~/IdeaProjects/microservices-full-code/services/customer/
kubectl delete -f ~/IdeaProjects/microservices-full-code/services/gateway/
kubectl delete -f ~/IdeaProjects/microservices-full-code/services/notification/
kubectl delete -f ~/IdeaProjects/microservices-full-code/services/order/
kubectl delete -f ~/IdeaProjects/microservices-full-code/services/payment/
kubectl delete -f ~/IdeaProjects/microservices-full-code/services/product/





curl http://gateway-service:8222/actuator/env | grep zipkin

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
