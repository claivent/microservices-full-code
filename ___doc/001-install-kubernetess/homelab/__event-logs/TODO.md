````
[x] Nastavit síť pomocí Netplanu (bridge, VLAN pokud je potřeba).
[x] Bind9 – primár AZ1, sekundár AZ2
[x] apt install bind9 bind9-utils bind9-dnsutils (AZ1, AZ2)
[x] named.conf.options (recursion, forwarders, listen, ACL)
[x] Zóna lab.claivent.website (master AZ1, secondary AZ2)
[x] Test dig @AZ1/@AZ2 (A a recursion)
[x] Kea DHCP – fáze 1 (LAN)
[x] apt install kea-dhcp4-server kea-ctrl-agent (AZ1)
[x] kea-dhcp4.conf (pool 10.0.20.100-199, GW 10.0.20.1, DNS 10.0.20.11/12)
[x] MikroTik: disable dhcp-lan
[ ] Test přidělení adresy v LAN
[ ] Kea DHCP – fáze 2 (DMZ)
[ ] MikroTik: /ip dhcp-relay add interface=dmz dhcp-server=10.0.20.11
[ ] (nebo přidat 2. NIC do AZ1 na VMnet2)
[ ] MikroTik: disable dhcp-dmz po ověření
[ ] (Volit.) DDNS: Kea → Bind9 (TSIG), rezervační hostname do zóny

## Síť & DNS & DHCP
[x] VMware VMnet2 (DMZ), VMnet3 (LAN), vypnutý VMware DHCP
[x] MikroTik: GW 10.0.10.254/10.0.20.254, NAT, FW, pravidla DMZ→LAN (53/udp,tcp; NodePorty)
[x] Statické IP: LB1=10.0.10.11, LB2=10.0.10.12, AZ1=10.0.20.11, AZ2=10.0.20.12
[x] Bind9: master (AZ1), secondary (AZ2) pro lab.claivent.website
[x] Kea DHCPv4 HA (hot-standby) pro LAN, CA API 8000, lease_cmds hook
[ ] (Volitelně) DMZ DHCP přes MikroTik DHCP Relay → Kea (LB1/LB2 zatím zůstávají statické)

## Edge LB vrstva (DMZ)
[ ] LB1: HAProxy + Keepalived (MASTER), VIP 10.0.10.9
[ ] LB2: HAProxy + Keepalived (BACKUP), VIP 10.0.10.9
[ ] Test VIP/VRRP failover (stop keepalived na LB1 → VIP na LB2)
[ ] Test HTTP přes VIP → backends (AZ1/AZ2)

## Origin vrstva (LAN)
[ ] AZ1: HAProxy (lokální origin + /healthz), případně Nginx demo na 8080
[ ] AZ2: HAProxy (lokální origin + /healthz), případně Nginx demo na 8080
[ ] (Volitelně později) nahradit origin za Kubernetes Gateway/NodePort

## Monitoring a housekeeping
[ ] systemd jednotky enabled, logy OK
[ ] Skript na rychlou kontrolu: VIP stav, HAProxy backendy, DNS/HTTP testy

````
