>```shell
>minikube version
>```
>> output:  
>>  minikube version: v1.36.0  
>>  commit: f8f52f5de11fc6ad8244afac475e1d0f96841df1-dirty


>```shell
>minikube config view
>```
>> output:  

```shell
minikube addons enable ingress
```

```shell
kubectl get pods -n ingress-nginx

```
```shell
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```
```shell
chmod 700 get_helm.sh
./get_helm.sh
```