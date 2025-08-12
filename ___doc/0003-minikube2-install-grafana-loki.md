##  Vytvoř soubor values.yaml:
```shell
grafana:
  enabled: true
  adminUser: admin
  adminPassword: admin
  service:
    type: ClusterIP
    port: 80
  persistence:
    enabled: false
#  datasources:
#    datasources.yaml:
#      apiVersion: 1
#      datasources:
#        - name: Loki
#          type: loki
#          access: proxy
#          url: http://loki:3100
#          isDefault: true
#          editable: true

loki:
  enabled: true
  isDefault: true
  persistence:
    enabled: false

promtail:
  enabled: true
  config:
    lokiAddress: http://loki:3100/loki/api/v1/push

```

## 2. Přidej Helm repo
```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

```

##  3. Instaluj Loki Stack
```shell
helm upgrade --install loki grafana/loki-stack -n default --values values.yaml

```
## Přístup do Grafany:
```shell
kubectl get pods -n default
```
## port forward
```shell
kubectl port-forward svc/loki-grafana 3000:80 -n default
```
zkontroluj že funguje 

# přidání pvc a ingress
## uprav values.yaml
```shell
grafana:
  enabled: true
  adminUser: admin
  adminPassword: admin
  service:
    type: ClusterIP
    port: 80
  persistence:
    enabled: true
    type: pvc
    storageClassName: "standard"
    accessModes:
      - ReadWriteOnce
    size: 1Gi
  datasources:
    datasources.yaml:
      apiVersion: 1
      datasources:
        - name: Loki
          type: loki
          access: proxy
          url: http://loki:3100
          isDefault: true
          editable: true
  ingress:
    enabled: true
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
    path: /
    pathType: Prefix
    hosts:
      - grafana.local
    tls: []

loki:
  enabled: true
  isDefault: true
  persistence:
    enabled: false

promtail:
  enabled: true
  config:
    lokiAddress: http://loki:3100/loki/api/v1/push
 
```

Deploy:  
Po úpravě values.yaml spusť:  
```shell
helm upgrade --install loki grafana/grafana \
  --namespace default \
  --values values.yaml

```


# odinstalace grafana
```shell
helm list -n default
output: 
NAME    NAMESPACE       REVISION        UPDATED                                         STATUS          CHART           APP VERSION
loki    default         5               2025-08-05 12:20:55.816708705 +0200 CEST        deployed        grafana-9.3.1   12.1.0  

helm uninstall loki -n default
```

##  Smaž zbylé objekty, které Helm neodstranil

```shell
kubectl delete svc,cm,secret,pod,pvc,pv,sts,deploy,ds -l app.kubernetes.io/instance=loki -n default

kubectl get all -n default | grep -i 'loki\|grafana'

kubectl delete pod loki-0 -n default

# zkontroluj že je vše pryč

kubectl get pods -n default
kubectl get svc -n default
kubectl get configmap -n default
```

