https://helm.sh/docs/intro/install/


````shell
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
 ./get_helm.sh
````

## Initialize a Helm Chart Repository
````shell
helm repo add bitnami https://charts.bitnami.com/bitnami
````

## Install an Example Chart
````shell
helm repo update              # Make sure we get the latest list of charts
helm install bitnami/mysql --generate-name

helm list
````

```` 
claiv@DESKTOP-CR4D3HV:/mnt/c/Users/claiv$ helm list
NAME                    NAMESPACE       REVISION        UPDATED                                         STATUS          CHART           APP VERSION
mysql-1756115454        default         1               2025-08-25 11:50:55.437667081 +0200 CEST        deployed        mysql-14.0.3    9.4.0
claiv@DESKTOP-CR4D3HV:/mnt/c/Users/claiv$
````

## uninstall chart 
````shell
helm uninstall mysql-1756115454
````

helm get -h  
