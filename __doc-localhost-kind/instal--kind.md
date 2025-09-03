wsl --install -d Ubuntu-24.04 --name tk

Super 👍 – takže máš nainstalovaný WSL s Ubuntu-22.04 a chceš do něj nainstalovat Kind (Kubernetes in Docker) pro testovací cluster.

Postup v Ubuntu (uvnitř WSL):

1. Aktualizuj balíčky
   sudo apt update && sudo apt upgrade -y

2. Nainstaluj Docker (Kind ho potřebuje)
   sudo apt install -y docker.io
   sudo usermod -aG docker $USER


👉 Pak buď restartuj WSL (wsl --shutdown) nebo se znovu přihlas (exit a znova wsl -d tk), aby se skupiny načetly.

3. Stáhni Kind binárku
   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
   chmod +x ./kind
   sudo mv ./kind /usr/local/bin/kind

4. Ověř instalaci
   kind --version

5. Vytvoř testovací cluster
   kind create cluster --name test

6. Ověř funkčnost
   kubectl cluster-info --context kind-test


💡 Poznámka:

Kubectl není součástí Kindu, takže ho nainstaluj taky:

sudo apt install -y kubectl


nebo aktuální release:

curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/  

```
kubectl cluster-info --context kind-test

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
claiv@DESKTOP-CR4D3HV:/mnt/c/Users/claiv$ kubectl cluster-info --context kind-test
Kubernetes control plane is running at https://127.0.0.1:44259
CoreDNS is running at https://127.0.0.1:44259/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
claiv@DESKTOP-CR4D3HV:/mnt/c/Users/claiv$
```
Jo, v Ubuntu 24.04 není kubectl v oficiálních apt repozitářích, proto ti to hlásí jen snap verzi.
Doporučený způsob je přidat oficiální Kubernetes repozitář a nainstalovat kubectl odtud.  

Postup pro instalaci kubectl (aktuální stable verze):
# 1. Přidej GPG klíč Kubernetes
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# 2. Přidej repozitář
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 3. Aktualizuj seznam balíčků
sudo apt update

# 4. Instaluj kubectl
sudo apt install -y kubectl



Poznámky (WSL specifika)

Docker Desktop pro Windows: nejjednodušší je mít Docker Desktop a v nastavení povolit WSL integration pro tvoje Ubuntu 24.04. Skript pak Kind bez problémů použije.

Docker Engine přímo ve WSL: potřebuje systemd. V /etc/wsl.conf dej:

[boot]
systemd=true


a pak v PowerShellu: wsl --shutdown a znovu spusť Ubuntu.

Když narazíš na chybu (např. docker daemon not running), po zapnutí Dockeru už stačí jen:

kind create cluster --name kind-test
kubectl cluster-info --context kind-kind-test



----------------------  
kind get clusters

# 2) Vytvoř kubeconfig pro Kind do výchozí cesty
mkdir -p ~/.kube
kind export kubeconfig --name kind-test
# (pokud by export nešel, alternativně:)
# kind get kubeconfig --name kind-test > ~/.kube/config

# 3) Přepni context na Kind
kubectl config get-contexts
kubectl config use-context kind-kind-test

# 4) Ověř
kubectl cluster-info
kubectl get nodes


