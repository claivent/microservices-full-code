# Kubernetes Cluster – VMware Workstation 17 Lab (Cilium)

## 1. Vytvoření základní VM
- **OS:** Ubuntu Server (minimized)
- **Disk:** 60 GB (LVM, bez šifrování)
- **RAM/CPU:** 2 vCPU, 2 GB RAM (lze později navýšit)
- **Síť:**
  - Network Adapter 1 → **Host-only** (statická IP, pro cluster)
  - Network Adapter 2 → **NAT** (DHCP, pro internet)

## 2. Instalace systému
### Boot menu
- Vyber: `Try or Install Ubuntu Server` (bez HWE kernelu).
- Zvol: `Ubuntu Server (minimized)`.

### Síťová konfigurace
- **ens33 (NAT):** DHCP (pro internet).
- **ens34 (Host-only):** statická IP.
  - cp1 → `192.168.100.111/24`
  - cp2 → `192.168.100.112/24`
  - cp3 → `192.168.100.113/24`
  - w1  → `192.168.100.114/24`
  - w2  → `192.168.100.115/24`
- Gateway a DNS na ens34 nevyplňuj (postačí NAT interface).

### Disky
- Použij celý disk `/dev/sda` (60 GB).
- LVM povolit.
- Bez šifrování (LUKS nepotřebujeme).
- `/` → ~29 GB ext4  
- `/boot` → 2 GB ext4  
- Zbytek prostoru ve volume group jako rezerva.

### Uživatelský účet
- Server name = hostname (`cp1`, `cp2`, `cp3`, `w1`, `w2`).
- Username = `claivent`.
- Heslo → stejné na všech nodech.

### SSH
- Zaškrtnout: **Install OpenSSH server**.
- Povolit password authentication.

### Featured snaps
- Nic neinstalovat (docker, microk8s, lxd, … nechat prázdné).

---

## 3. Post-instalace (na všech nodech)
```bash
# Update systému
sudo apt update && sudo apt upgrade -y

# Základní balíčky
sudo apt install -y vim nano curl wget git unzip zip tar   htop net-tools iproute2 dnsutils traceroute   tcpdump lsof less software-properties-common   systemd-timesyncd ufw apt-transport-https ca-certificates gnupg2

# (volitelné) Python + build tools
sudo apt install -y python3 python3-pip build-essential
```
> **Tip:** Zapni časovou synchronizaci: `sudo systemctl enable --now systemd-timesyncd`

---

## 4. SSH klíče (pro snadný přístup mezi nody)
Na `cp1`:
```bash
ssh-keygen -t ed25519 -C "claivent@cluster"
# Enter pro default (~/.ssh/id_ed25519), bez hesla
```

Nahrát klíče na ostatní nody:
```bash
ssh-copy-id claivent@192.168.100.112
ssh-copy-id claivent@192.168.100.113
ssh-copy-id claivent@192.168.100.114
ssh-copy-id claivent@192.168.100.115
```

---

## 5. Containerd + Kubernetes (na všech nodech)

### Kernel moduly + sysctl
```bash
# moduly
echo -e "overlay
br_netfilter" | sudo tee /etc/modules-load.d/containerd.conf
sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl
cat <<'EOF' | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
```

### Containerd
```bash
sudo apt install -y containerd

# Default config
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# cgroup driver = systemd + sjednotit pause image
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo sed -i 's#^\s*sandbox_image = ".*"#  sandbox_image = "registry.k8s.io/pause:3.9"#' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
```

### Kubernetes (repo + balíčky)
```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gpg

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key |   sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" |   sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# vypnout swap (nutné pro kubelet)
sudo swapoff -a
sudo sed -i.bak '/\sswap\s/ s/^/#/' /etc/fstab
```

---

## 6. Inicializace clusteru

### Na cp1
```bash
sudo kubeadm reset -f

sudo kubeadm init   --control-plane-endpoint=192.168.100.111   --pod-network-cidr=10.244.0.0/16
```

Po úspěchu:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Poznamenej si `kubeadm join ...` příkazy pro control-plane i worker nody.

---

## 7. Síť (CNI) — Cilium (doporučeno)

> Tento lab používá **Cilium** jako CNI. Flannel **neinstalujeme**.

Po `kubeadm init` nainstaluj Cilium přes **Helm** (detaily viz kap. 9–12):

```bash
helm repo add cilium https://helm.cilium.io
helm repo update

helm install cilium cilium/cilium   --namespace kube-system   --set hubble.relay.enabled=true   --set hubble.ui.enabled=true
```

Ověření:
```bash
kubectl -n kube-system get pods -l k8s-app=cilium
kubectl -n kube-system get deploy hubble-relay
kubectl -n kube-system get deploy hubble-ui
```

---

## 8. Připojení uzlů a test
```bash
# na cp2, cp3, w1, w2 použij 'kubeadm join ...' z výstupu initu
kubectl get nodes
kubectl get pods -A
```

---

## 9. Helm CLI (instalace na Ubuntu/Debian)

```bash
# přidej oficiální Helm APT repozitář
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install -y apt-transport-https
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" |   sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# instalace Helm CLI
sudo apt-get update
sudo apt-get install -y helm

# ověření
helm version
```

---

## 10. Cilium přes Helm (detail)

```bash
helm repo add cilium https://helm.cilium.io
helm repo update

helm install cilium cilium/cilium   --namespace kube-system   --set hubble.relay.enabled=true   --set hubble.ui.enabled=true
```
Lokální otevření Hubble UI (port-forward):
```bash
kubectl -n kube-system port-forward svc/hubble-ui 12000:80
# http://localhost:12000
```

---

## 11. cilium-cli (`cilium status`)

```bash
# stáhni poslední stabilní verzi
VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
curl -L --remote-name https://github.com/cilium/cilium-cli/releases/download/${VERSION}/cilium-linux-amd64.tar.gz
curl -L --remote-name https://github.com/cilium/cilium-cli/releases/download/${VERSION}/cilium-linux-amd64.tar.gz.sha256sum

# ověř kontrolní součet (volitelné)
sha256sum --check cilium-linux-amd64.tar.gz.sha256sum

# nainstaluj do /usr/local/bin
sudo tar xzvf cilium-linux-amd64.tar.gz -C /usr/local/bin
cilium version

# kontrola stavu
cilium status --wait
cilium hubble status
```

---

## 12. Poznámky pro kubeadm cluster
- Výchozí instalace ponechává **kube-proxy** (replacement nezapínáme).
- `--pod-network-cidr=10.244.0.0/16` je v pořádku i pro Cilium; jen nesmí kolidovat s tvou L2/L3 sítí.
- Při klonování VM vždy změň `hostname`, `machine-id` a regeneruj SSH host klíče.

---

## 13. (Volitelné) Sjednocení sandbox image (pause:3.9)

Pokud kubeadm varuje na rozdíl `pause:3.8 vs 3.9`, oprav containerd:

```bash
sudo sed -i 's#^\s*sandbox_image = ".*"#  sandbox_image = "registry.k8s.io/pause:3.9"#' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl restart kubelet
```

---

## 14. Troubleshooting kubelet (healthz 10248)

Když `kubeadm` hlásí:
`Get "http://127.0.0.1:10248/healthz": context deadline exceeded`

Zkontroluj:
```bash
# logy
systemctl status kubelet --no-pager -l
journalctl -xeu kubelet --no-pager | tail -n 100

# swap musí být vypnutý
sudo swapoff -a
swapon --show
# moduly + sysctl viz kapitola 5
# containerd běží a má SystemdCgroup=true, pause:3.9
```


---

## 15. HA control-plane (VIP + HAProxy + Keepalived)

> Cíl: mít stabilní API endpoint `192.168.100.150:6443` na Host-only síti, který přežije výpadek jednoho CP uzlu.

### 15.1 Zvol VIP
- Použij VIP: **192.168.100.150/24** (mimo rozsah přidělených IP nodů).
- Rozhraní s VIP bude **ens34** (Host-only).

### 15.2 Instalace HAProxy + Keepalived (na cp1 a cp2; volitelně i cp3)
```bash
sudo apt update
sudo apt install -y haproxy keepalived
```

**/etc/haproxy/haproxy.cfg** (doplň na **cp1** i **cp2**; HAProxy může bindovat na 0.0.0.0):
```cfg
global
    log /dev/log local0
    maxconn 2048
    daemon

defaults
    log     global
    mode    tcp
    option  tcplog
    option  dontlognull
    timeout connect 10s
    timeout client  1m
    timeout server  1m

frontend k8s_api_frontend
    bind 0.0.0.0:6443
    default_backend k8s_api_backend

backend k8s_api_backend
    balance roundrobin
    option tcp-check
    server cp1 192.168.100.111:6443 check
    server cp2 192.168.100.112:6443 check
    server cp3 192.168.100.113:6443 check
```

**/etc/keepalived/keepalived.conf** (na cp1 – MASTER):
```cfg
vrrp_instance VI_1 {
    state MASTER
    interface ens34
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 42secret
    }
    virtual_ipaddress {
        192.168.100.150/24
    }
}
```

**/etc/keepalived/keepalived.conf** (na cp2 – BACKUP; na cp3 můžeš přidat priority 80):
```cfg
vrrp_instance VI_1 {
    state BACKUP
    interface ens34
    virtual_router_id 51
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 42secret
    }
    virtual_ipaddress {
        192.168.100.150/24
    }
}
```

Zapni služby (na cp1 i cp2):
```bash
sudo systemctl enable --now haproxy
sudo systemctl enable --now keepalived
```

> VIP `192.168.100.150` bude aktivní na **cp1**. Při výpadku cp1 se přesune na **cp2**. HAProxy bude vždy poslouchat na :6443 a přeposílat na zdravé apiservery.

### 15.3 Inicializace clusteru s VIP
Na **cp1** (jak je uvedeno v kap. 6) už používáme:
```bash
sudo kubeadm init   --control-plane-endpoint=192.168.100.150:6443   --pod-network-cidr=10.244.0.0/16   --upload-certs
```
Z výstupu si **ulož**:
- `--discovery-token-ca-cert-hash sha256:...`
- `--token <xxxxxx.yyyyyy>`
- `--certificate-key <AAAAAAAAA...>` (pro join control-plane)

---

## 16. Join dalších control-plane uzlů (cp2, cp3)

Na **cp2** a **cp3** použij příkaz ve tvaru (nahraď hodnotami z `kubeadm init`):
```bash
sudo kubeadm join 192.168.100.150:6443   --token <TOKEN>   --discovery-token-ca-cert-hash sha256:<HASH>   --control-plane   --certificate-key <CERT_KEY>
```

> Pokud `CERT_KEY` nemáš po ruce, můžeš ho znovu vypsat na cp1:
> ```bash
> sudo kubeadm init phase upload-certs --upload-certs
> ```

Po úspěchu by měly běžet 3× apiserver/controllermanager/scheduler a 3× etcd (všude `Ready`).

---

## 17. Join workerů (w1, w2)

Na **w1** a **w2** použij worker join (bez `--control-plane`):
```bash
sudo kubeadm join 192.168.100.150:6443   --token <TOKEN>   --discovery-token-ca-cert-hash sha256:<HASH>
```
Kdyby token expiroval, na **cp1** si vygeneruj nový:
```bash
kubeadm token create --print-join-command
```

---

## 18. Ověření a značení rolí

```bash
kubectl get nodes -o wide

# Označ kontrolní roviny labely (informativní)
kubectl label node cp1 node-role.kubernetes.io/control-plane=
kubectl label node cp2 node-role.kubernetes.io/control-plane=
kubectl label node cp3 node-role.kubernetes.io/control-plane=

# Pokud chceš plánovat workload i na CP uzlech (nedoporučeno v produkci):
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

---

## 19. Shrnutí sítě a IP

| Node | Role | Host-only (statická) | VIP (API) |
|---|---|---|---|
| cp1 | control-plane | 192.168.100.111/24 | **192.168.100.150:6443** (přes HAProxy+Keepalived – MASTER) |
| cp2 | control-plane | 192.168.100.112/24 | záloha VIP (BACKUP) |
| cp3 | control-plane | 192.168.100.113/24 | (volitelně BACKUP) |
| w1  | worker        | 192.168.100.114/24 | — |
| w2  | worker        | 192.168.100.115/24 | — |

