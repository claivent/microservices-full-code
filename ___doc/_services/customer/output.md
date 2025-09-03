````
root@cp1:~/demo# k get nodes -o json |jq '.items[].spec.podCIDRs'
[
"10.244.0.0/24"
]
[
"10.244.1.0/24"
]
[
"10.244.4.0/24"
]
[
"10.244.3.0/24"
]
[
"10.244.2.0/24"
]
root@cp1:~/demo# k get nodes
NAME   STATUS   ROLES           AGE    VERSION
cp1    Ready    control-plane   151d   v1.30.11
cp2    Ready    control-plane   151d   v1.30.11
cp3    Ready    control-plane   9d     v1.30.14
w1     Ready    <none>          151d   v1.30.11
w2     Ready    <none>          151d   v1.30.11
root@cp1:~/demo# k get nodes -o wide
NAME   STATUS   ROLES           AGE    VERSION    INTERNAL-IP       EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
cp1    Ready    control-plane   151d   v1.30.11   192.168.100.111   <none>        Ubuntu 22.04.5 LTS   6.8.0-78-generic   containerd://1.7.27
cp2    Ready    control-plane   151d   v1.30.11   192.168.100.112   <none>        Ubuntu 22.04.5 LTS   6.8.0-78-generic   containerd://1.7.26
cp3    Ready    control-plane   9d     v1.30.14   192.168.100.123   <none>        Ubuntu 22.04.5 LTS   6.8.0-78-generic   containerd://1.7.27
w1     Ready    <none>          151d   v1.30.11   192.168.100.113   <none>        Ubuntu 22.04.5 LTS   6.8.0-78-generic   containerd://1.7.26
w2     Ready    <none>          151d   v1.30.11   192.168.100.114   <none>        Ubuntu 22.04.5 LTS   6.8.0-78-generic   containerd://1.7.26
root@cp1:~/demo# kgp -o wide |grep nginx
nginx-deployment-1-8bcb48b6c-8wjd4   1/1     Running   0               3d21h   10.0.3.70    w1     <none>           <none>
nginx-deployment-1-8bcb48b6c-g2p26   1/1     Running   0               3d21h   10.0.2.123   w2     <none>           <none>
````


````shell
kubectl run alpine --image=alpine -it
````
````
apk update
apk add bind-tools curl
````

```` 
/ # curl 10.0.3.70
<html>
<h2>Hello world 1!!</h2>
</html>

/ # curl 10.0.2.123
<html>
<h2>Hello world 1!!</h2>
</html>
/ #
````

```` 
 # host nginx-headless
nginx-headless.default.svc.cluster.local has address 10.244.5.2
nginx-headless.default.svc.cluster.local has address 10.244.4.2
nginx-headless.default.svc.cluster.local has address 10.244.3.2
/ #
````

```` 
kubectl describe pod nginx-deployment-1-8bcb48b6c-g2p26 | grep IP| grep fc
````
```` 
docker exec -it kind-test-control-plane bash
````
root@kind-test-control-plane:/# iptables -t nat -nvL KUBE-SERVICES

```` 
claiv@DESKTOP-CR4D3HV:/mnt/c/_M/szz/microservices/__doc-localhost-kind$ docker exec -it kind-test-control-plane bash
root@kind-test-control-plane:/# iptables -t nat -nvL KUBE-SERVICES
Chain KUBE-SERVICES (2 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 KUBE-SVC-JD5MR3NA4I4DYORP  6    --  *      *       0.0.0.0/0            10.96.0.10           /* kube-system/kube-dns:metrics cluster IP */ tcp dpt:9153
    0     0 KUBE-SVC-PV5PUP4CQH7C4UEJ  6    --  *      *       0.0.0.0/0            10.101.51.39         /* default/nginx:80 cluster IP */ tcp dpt:80
    0     0 KUBE-SVC-NPX46M4PTMTKRN6Y  6    --  *      *       0.0.0.0/0            10.96.0.1            /* default/kubernetes:https cluster IP */ tcp dpt:443
    0     0 KUBE-SVC-TCOU7JCQXEZGVUNU  17   --  *      *       0.0.0.0/0            10.96.0.10           /* kube-system/kube-dns:dns cluster IP */ udp dpt:53
    0     0 KUBE-SVC-ERIFXISQEP7F7OF4  6    --  *      *       0.0.0.0/0            10.96.0.10           /* kube-system/kube-dns:dns-tcp cluster IP */ tcp dpt:53
 2053  123K KUBE-NODEPORTS  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes service nodeports; NOTE: this must be the last rule in this chain */ ADDRTYPE match dst-type LOCAL
root@kind-test-control-plane:/# iptables -t nat -nvL KUBE-SVC-JD5MR3NA4I4DYORP
Chain KUBE-SVC-JD5MR3NA4I4DYORP (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 KUBE-MARK-MASQ  6    --  *      *      !10.244.0.0/16        10.96.0.10           /* kube-system/kube-dns:metrics cluster IP */ tcp dpt:9153
    0     0 KUBE-SEP-ZP3FB6NMPNCO4VBJ  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:metrics -> 10.244.0.3:9153 */ statistic mode random probability 0.50000000000
    0     0 KUBE-SEP-PUHFDAMRBZWCPADU  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:metrics -> 10.244.0.4:9153 */
root@kind-test-control-plane:/#
````
