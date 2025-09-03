#!/usr/bin/env bash
set -euo pipefail

# === Nastavení verzí (můžeš změnit) ===
K8S_REPO_SERIES="v1.32"
KIND_VERSION="${KIND_VERSION:-v0.24.0}"

# === Pomůcky ===
msg(){ echo -e "\n\033[1;32m[INFO]\033[0m $*\n"; }
warn(){ echo -e "\n\033[1;33m[WARN]\033[0m $*\n"; }
err(){ echo -e "\n\033[1;31m[ERR]\033[0m  $*\n"; }

# === 0) Základní balíčky ===
msg "Instaluji základní nástroje…"
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https

# === 1) Docker (Engine + CLI) ===
if ! command -v docker >/dev/null 2>&1; then
  msg "Instaluji Docker Engine z oficiálního repozitáře…"
  # GPG klíč
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Repozitář
  UB_CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UB_CODENAME} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || {
    err "Instalace Dockeru selhala."; exit 1;
  }

  # Přidat uživatele do skupiny docker (bez sudo)
  if getent group docker >/dev/null 2>&1; then
    sudo usermod -aG docker "$USER" || true
    warn "Pokud je to poprvé, odhlaš se a znovu přihlaš do WSL, aby se načetla skupina 'docker'."
  fi
else
  msg "Docker už je k dispozici — přeskakuji instalaci."
fi

# === 2) kubectl (Kubernetes CLI) z oficiálního repa ===
if ! command -v kubectl >/dev/null 2>&1; then
  msg "Přidávám oficiální Kubernetes repozitář a instaluji kubectl…"
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_REPO_SERIES}/deb/Release.key" \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod a+r /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_REPO_SERIES}/deb/ /" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

  sudo apt update
  sudo apt install -y kubectl
else
  msg "kubectl už je k dispozici — přeskakuji instalaci."
fi

# === 3) Kind (Kubernetes in Docker) ===
if ! command -v kind >/dev/null 2>&1; then
  msg "Stahuji Kind ${KIND_VERSION}…"
  curl -Lo kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
  chmod +x kind
  sudo mv kind /usr/local/bin/kind
else
  msg "Kind už je k dispozici — přeskakuji instalaci."
fi

# === 4) Ověření verzí ===
msg "Verze nástrojů:"
docker --version || warn "Docker zatím nemusí běžet (WSL/systemd)."
kubectl version --client --output=yaml || true
kind --version || true

# === 5) Pokus o vytvoření testovacího clusteru ===
CAN_RUN_DOCKER=0
if docker info >/dev/null 2>&1; then
  CAN_RUN_DOCKER=1
elif sudo -n docker info >/dev/null 2>&1; then
  CAN_RUN_DOCKER=1
fi

if [ "$CAN_RUN_DOCKER" -eq 1 ]; then
  msg "Vytvářím Kind cluster 'kind-test'…"
  if kind get clusters | grep -q "^kind-test$"; then
    warn "Cluster 'kind-test' už existuje — vytváření přeskočeno."
  else
    kind create cluster --name kind-test --config kind-3cp-3w.yaml
    kind export kubeconfig --name kind-test
    kubectl config use-context kind-kind-test
  fi
  msg "Cluster info:"
  kubectl cluster-info --context kind-kind-test || true
else
  warn "Docker daemon neběží. Přeskočeno vytváření Kind clusteru.
- Pokud používáš Docker Desktop pro Windows, povol WSL integraci pro tuto distro.
- Pokud máš Docker Engine přímo ve WSL, ujisti se, že je zapnutý systemd (ve /etc/wsl.conf: [boot] systemd=true) a potom proveď 'wsl --shutdown' a znovu otevři Ubuntu.
Po zprovoznění Dockeru spusť:  kind create cluster --name kind-test"
fi

msg "Hotovo. 🎉"
