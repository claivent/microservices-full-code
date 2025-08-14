1. Na uu: Nainstaluj NFS server
````shell
sudo apt update
sudo apt install -y nfs-kernel-server
```` 
2. Vytvoř složky a nastav oprávnění
```shell
sudo mkdir -p /var/k8s-volumes/mongo
sudo mkdir -p /var/k8s-volumes/postgres
sudo mkdir -p /var/k8s-volumes/pgadmin
sudo chown nobody:nogroup /var/k8s-volumes/* 
sudo chmod 777 /var/k8s-volumes/*
```
3. Uprav /etc/exports
```shell
sudo vim /etc/exports
```
Přidej řádky:
```
/var/k8s-volumes/mongo     192.168.100.0/24(rw,sync,no_subtree_check,no_root_squash)
/var/k8s-volumes/postgres  192.168.100.0/24(rw,sync,no_subtree_check,no_root_squash)
/var/k8s-volumes/pgadmin   192.168.100.0/24(rw,sync,no_subtree_check,no_root_squash)
```

4. Restartuj NFS server
```shell
sudo exportfs -ra
sudo exportfs -v
sudo systemctl restart nfs-kernel-server
```

5. 5. Na každém Kubernetes uzlu (např. w1, w2) připoj NFS
```shell
sudo apt update
sudo apt install -y nfs-common
sudo mkdir -p /mnt/data/mongo
sudo mount -t nfs 192.168.100.1:/var/k8s-volumes/mongo /mnt/data/mongo
sudo mkdir -p /mnt/data/postgres
sudo mount -t nfs 192.168.100.1:/var/k8s-volumes/postgres /mnt/data/postgres
sudo mkdir -p /mnt/data/pgadmin
sudo mount -t nfs 192.168.100.1:/var/k8s-volumes/pgadmin /mnt/data/pgadmin
```
zkontoluji:  
```shell
df -h | grep mongo
```
pokud ok, přidej do /etc/fstab
```shell
sudo vim /etc/fstab
```
Přidej řádky:
```
192.168.100.1:/var/k8s-volumes/mongo /mnt/data/mongo nfs defaults 0 0
192.168.100.1:/var/k8s-volumes/postgress /mnt/data/postgress nfs defaults 0 0
192.168.100.1:/var/k8s-volumes/pgadmin /mnt/data/pgadmin nfs defaults 0 0
```




6. Kubernetes PersistentVolume a hostPath bez nodeAffinity
```yaml
---
# mongo-pv-pvc.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongo-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /mnt/data/mongo
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongo-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
---
``` 

