#!/bin/bash

# == [0] POZOR: Tento kontejner potřebuje /dev/kmsg pro správný běh kubeletu.
# Přidej na hostu:
#   incus config device add cp1 kmsg unix-char path=/dev/kmsg major=1 minor=11 mode=0666
# A restartuj kontejner:
#   incus restart cp1

set -e

echo "== [1] Umožňuji sudo bez hesla pro uživatele claivent =="
echo "claivent ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "== [2] Aktualizuji systém =="
apt-get update
apt-get dist-upgrade -y

echo "== [3] Instaluji základní nástroje =="
apt-get install -y apt-transport-https gnupg ca-certificates curl software-properties-common inetutils-traceroute

echo "== [4] Odstraňuji staré Docker/PODMAN balíky =="
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  apt-get remove -y $pkg || true
done

echo "== [5] Přidávám Docker GPG klíč a repozitář =="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
> /etc/apt/sources.list.d/docker.list

apt-get update

echo "== [6] Instaluji Docker a containerd =="
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "== [7] Přidávám uživatele $USER do skupiny docker =="
usermod -aG docker "$USER"

echo "== [8] Testuji Docker hello-world =="
docker run hello-world || echo "→ Docker se spustí až po restartu session."

echo "== [9] Vypínám swap a zakomentuji jej =="
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

echo "== [10] Načítám kernel moduly overlay a br_netfilter =="
echo "Vynechávám moduly se sdílí přes hosta v config přidány"
#modprobe overlay
#modprobe br_netfilter

echo -e "overlay\nbr_netfilter" > /etc/modules-load.d/k8s.conf

echo "== [11] Nastavuji IP forward =="
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/k8s.conf

echo "== [12] Načítám sysctl nastavení =="
sysctl --system

echo "== [13] Vytvářím výchozí konfigurační soubor pro containerd =="
containerd config default | tee /etc/containerd/config.toml >/dev/null

echo "== [14] Měním SystemdCgroup = true v /etc/containerd/config.toml =="
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

echo "== [15] Restartuji containerd =="
systemctl restart containerd
systemctl status containerd --no-pager

echo "== [16] Přidávám Kubernetes repozitář =="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/k8s.gpg

echo 'deb [signed-by=/etc/apt/keyrings/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' \
> /etc/apt/sources.list.d/k8s.list

apt-get update

echo "== [17] Instaluji kubelet, kubeadm, kubectl =="
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "== ✅ Hotovo! ✅ Restartuj shell/session, aby se Docker group aktivovala pro $USER. =="
