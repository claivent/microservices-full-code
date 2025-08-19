
https://api.ipify.org/  

```shell
kubectl -n kubernetes-dashboard create token k8s-dashboard --duration=24h
```


```
kubectl apply -f   service/config-server/
kubectl apply -f   service/discovery-service/
kubectl apply -f   service/customer-service/
```

```
docker build --no-cache -t claivent/micro:config-server-0.1.11 .
docker push claivent/micro:config-server-0.1.11
```



https://ifconfig.me

https://api.ipify.org

https://whatismyipaddress.com