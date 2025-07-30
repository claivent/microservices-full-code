A very popular software package that can provide this functionality is Envoy
### 5.4.1 Extending the Kiada Node.js application using the Envoy proxy


```yaml
# kiada-ssl.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kiada-ssl
spec:
  containers:
    - name: kiada
      image: claivent/kiada:0.2
      stdin: true
      ports:
        - name: http
          containerPort: 8080
    - name: envoy
      image: claivent/kiada-ssl-proxy:0.1
      ports:
        - name: https
          containerPort: 8443
        - name: admin
          containerPort: 9901
```
```shell
kubectl apply -f kiada-ssl.yaml 
```

## port forward tři porty

```shell
kubectl port-forward kiada-ssl 8080 8443 9901
```
```shell
curl https://localhost:8080
```
```shell
curl https://localhost:8443 --insecure
```

```shell
curl https://example.com:8443 --resolve example.com:8443:127.0
```


## máme v podu dva kontejnery


```shell
kubectl logs kiada-ssl -c kiada

kubectl logs kiada-ssl -c envoy

kubectl logs kiada-ssl --all-containers

kubectl exec -it kiada-ssl -c envoy -- bash
```
