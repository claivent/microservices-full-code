## create deployment declarative

```bash 
 kubectl create deployment kiada --image=luksa/kiada:0.2
 ```

```bash
kubectl expose deployment kiada --type=LoadBalancer --port 8080
```



```bash
kubectl scale deployment kiada --replicas=1
```






