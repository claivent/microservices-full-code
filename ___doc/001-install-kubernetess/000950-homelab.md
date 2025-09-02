# Homelab na Ubuntu

Tento dokument shrnuje doporuèenı stack pro homelab bìící na **Ubuntu Server LTS**.  
Je rozdìlen do oblastí: infrastruktura, sí, virtualizace, úloištì, bezpeènost, monitoring a aplikaèní sluby.

---

## ? Základní infrastruktura
- **Ubuntu Server LTS** – stabilní základ s dlouhou podporou.
- **OpenSSH** – vzdálená správa serveru.
- **Cockpit** – webové rozhraní pro správu systému.
- **ZFS on Linux** – pokroèilı filesystem se snapshoty a kompresí.

---

## ? Sí a vysoká dostupnost
- **Netplan** – správa sítí (bridge, VLAN).
- **Bind9 + Kea DHCP** – DNS a DHCP server.
- **HAProxy + Keepalived** – load balancing a vysoká dostupnost s VIP adresou.
- **WireGuard VPN** – bezpeènı vzdálenı pøístup do homelabu.

---

## ?? Virtualizace a kontejnery
- **Incus (LXD)** – lehké VM a kontejnery.
- **Docker / Podman** – mikrosluby a rychlé nasazení aplikací.
- **MicroK8s** – Kubernetes distribuce od Canonicalu (snadná instalace a HA).

---

## ? Úloištì a data
- **NFS server** – sdílení storage mezi uzly (napø. pro Kubernetes PVC).
- **Samba server** – sdílení souborù pro Windows klienty.
- **Nextcloud** – osobní cloud (soubory, kalendáøe, fotky).
- **Ceph** – distribuované úloištì (pro experimenty).

---

## ? Uivatelská správa a bezpeènost
- **Keycloak** – centrální správa identit a SSO.
- **FreeIPA** – alternativa pro centralizovanou autentizaci.
- **AppArmor** – posílení zabezpeèení (souèást Ubuntu).

---

## ? Monitoring a logy
- **Prometheus + Grafana** – metriky a vizualizace.
- **Netdata** – jednoduchı real-time monitoring.
- **Loki** – sbìr logù (integrace s Grafanou).
- **Hubble (Cilium)** – sledování síového provozu v Kubernetes.

---

## ? Aplikaèní sluby
- **Databáze:** PostgreSQL, MySQL/MariaDB, MongoDB.
- **Webové servery:** Nginx, Apache.
- **CI/CD a Git:** Gitea nebo GitLab.
- **Chytrá domácnost:** Home Assistant, OpenHAB.

---

## ? Doporuèenı startovací stack
- Ubuntu Server + ZFS
- OpenSSH + Cockpit
- Incus pro VM a kontejnery
- Docker pro mikrosluby
- MicroK8s pro Kubernetes (volitelnì)
- NFS server pro storage
- HAProxy + Keepalived pro vysokou dostupnost
- Prometheus + Grafana pro monitoring
- Keycloak pro správu identit

---
