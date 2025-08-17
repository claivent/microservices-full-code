# Kubernetes Cluster – VMware Workstation 17 Lab

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
- Klíče nastavíme později.

### Featured snaps
- Nic neinstalovat (docker, microk8s, lxd, … nechat prázdné).

---

## 3. Post-instalace (na všech nodech)
```bash
# Update systému
sudo apt update && sudo apt upgrade -y

# Základní balíčky
sudo apt install -y vim nano curl wget git unzip zip tar   htop net-tools iproute2 dnsutils traceroute   tcpdump lsof less software-properties-common   systemd-timesyncd ufw apt-transport-https ca-certificates gnupg2
```

Volitelné:
```bash
# Python + build tools
sudo apt install -y python3 python3-pip build-essential
```

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

Otestuj:
```bash
ssh claivent@192.168.100.112
```

---

## 5. Instalace containerd + Kubernetes (na všech nodech)

### Containerd
```bash
# Zapnout moduly
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Nastavit sysctl
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

# Instalace containerd
sudo apt install -y containerd

# Default config
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Použít systemd jako cgroup driver
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

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
```

---

## 6. Inicializace clusteru

### Na cp1
```bash
sudo kubeadm init --control-plane-endpoint=192.168.100.111 --pod-network-cidr=10.244.0.0/16
```

Po úspěchu:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Připojení dalších CP a workerů
Zkopíruj `kubeadm join` příkaz z výstupu `kubeadm init` a spusť ho na `cp2`, `cp3`, `w1`, `w2`.

---

## 7. Síť (CNI plugin)
Pro jednoduchost třeba Flannel:
```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

Nebo Cilium (pokročilejší, doporučeno pro seriózní lab).

---

## 8. Test
```bash
kubectl get nodes
kubectl get pods -A
```

Všechny nody by měly být **Ready**.
