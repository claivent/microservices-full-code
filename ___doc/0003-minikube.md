 ```bash
 curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

 ```
sudo chmod 666 /var/run/docker.sock
sudo addgroup --system docker
sudo adduser claiv docker
newgrp docker

```bash
minikube profile list
```
minikube service 'servis' --url
```bash
minikube start --nodes 3 --profile luksa-book --memory=2048 --cpus=2 
minikube start  --memory=8048 --cpus=6
```

```bash
minikube start -p luksa-book --memory=8196 
```

```bash
minikube stop --profile luksa-book
```

```bash
minikube delete --profile luksa-book
```

```bash
minikube ssh -p luksa-book -- grep MemTotal /proc/meminfo 
```
```bash
cat ~/.minikube/profiles/luksa-book/config.json
```

```bash
minikube config set memory 8196 -p luksa-book
```

```bash
minikube config view -p luksa-book
```

```bash
minikube -p luksa-book service kiada --url
```
