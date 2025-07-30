## connect to node via minikube
minikube ssh -p luksa-book

## Port forwarding
kubectl port-forward kiada 8080

## copy file in k8s
```bash
kubectl cp kiada:html/index.html /tmp/index.html
```
### Po editaci návrat zpět 
```bash
kubectl cp /tmp/index.html kiada:html/
```
