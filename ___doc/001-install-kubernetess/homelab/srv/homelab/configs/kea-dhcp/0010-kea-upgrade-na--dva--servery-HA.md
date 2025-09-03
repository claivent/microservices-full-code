# Kea DHCPv4 v režimu hot-standby

## primár na AZ1 (10.0.20.11), záložní na AZ2 (10.0.20.12). 

1. Předpoklady

> Obě VM v LAN 10.0.20.0/24 (stejné L2).

> Na LAN neběží jiný DHCP (MikroTik DHCP-LAN má být vypnutý).

> Čas synchronizovaný (NTP), kvůli HA.

> Pokud používáš UFW: sudo ufw allow 67/udp.

2. Instalace na OBOU uzlech

````shell
   sudo apt update
   sudo apt install -y kea-dhcp4-server kea-ctrl-agent
   sudo mkdir -p /etc/kea
````



## Rozhraní  ens33 

3. Control Agent (HTTP) – umožňuje HA komunikaci
   ## AZ1: /etc/kea/kea-ctrl-agent.conf
````json
{
  "Control-agent": {
    "http-host": "10.0.20.11",
    "http-port": 8000,
    "control-sockets": {
      "dhcp4": { "socket-type": "unix", "socket-name": "/run/kea/kea4-ctrl-socket" }
    }
  }
}
````

## AZ2: /etc/kea/kea-ctrl-agent.conf
````json
{
  "Control-agent": {
    "http-host": "10.0.20.12",
    "http-port": 8000,
    "control-sockets": {
      "dhcp4": { "socket-type": "unix", "socket-name": "/run/kea/kea4-ctrl-socket" }
    }
  }
}
````

4. # Kea DHCPv4 – hot-standby HA
   ## AZ1 (primár): /etc/kea/kea-dhcp4.conf

````json
{
  "interfaces-config": { "interfaces": [ "ens33" ] },
  "control-socket": { "socket-type": "unix", "socket-name": "/run/kea/kea4-ctrl-socket" },

  "lease-database": { "type": "memfile", "persist": true, "name": "/var/lib/kea/kea-leases4.csv" },

  "valid-lifetime": 3600,
  "renew-timer": 900,
  "rebind-timer": 1800,

  "subnet4": [{
    "subnet": "10.0.20.0/24",
    "pools": [ { "pool": "10.0.20.100 - 10.0.20.199" } ],
    "option-data": [
      { "name": "routers",              "data": "10.0.20.254" },
      { "name": "domain-name-servers",  "data": "10.0.20.11,10.0.20.12" },
      { "name": "domain-name",          "data": "lab.claivent.website" }
    ]
  }],

  "hooks-libraries": [{
    "library": "/usr/lib/x86_64-linux-gnu/kea/hooks/libdhcp_ha.so",
    "parameters": {
      "high-availability": [{
        "this-server-name": "az1",
        "mode": "hot-standby",
        "heartbeat-delay": 10000,
        "max-response-delay": 10000,
        "max-unacked-clients": 10,
        "peers": [
          { "name": "az1", "role": "primary",   "url": "http://10.0.20.11:8000/", "auto-failover": true },
          { "name": "az2", "role": "secondary", "url": "http://10.0.20.12:8000/" }
        ]
      }]
    }
  }]
}

````

## AZ2 (sekundár): /etc/kea/kea-dhcp4.conf

````json
{
  "interfaces-config": { "interfaces": [ "ens33" ] },
  "control-socket": { "socket-type": "unix", "socket-name": "/run/kea/kea4-ctrl-socket" },

  "lease-database": { "type": "memfile", "persist": true, "name": "/var/lib/kea/kea-leases4.csv" },

  "valid-lifetime": 3600,
  "renew-timer": 900,
  "rebind-timer": 1800,

  "subnet4": [{
    "subnet": "10.0.20.0/24",
    "pools": [ { "pool": "10.0.20.100 - 10.0.20.199" } ],
    "option-data": [
      { "name": "routers",              "data": "10.0.20.254" },
      { "name": "domain-name-servers",  "data": "10.0.20.11,10.0.20.12" },
      { "name": "domain-name",          "data": "lab.claivent.website" }
    ]
  }],

  "hooks-libraries": [{
    "library": "/usr/lib/x86_64-linux-gnu/kea/hooks/libdhcp_ha.so",
    "parameters": {
      "high-availability": [{
        "this-server-name": "az2",
        "mode": "hot-standby",
        "heartbeat-delay": 10000,
        "max-response-delay": 10000,
        "max-unacked-clients": 10,
        "peers": [
          { "name": "az1", "role": "primary",   "url": "http://10.0.20.11:8000/" },
          { "name": "az2", "role": "secondary", "url": "http://10.0.20.12:8000/", "auto-failover": true }
        ]
      }]
    }
  }]
}

````

## Poznámky:

> mode: hot-standby → odpovídá pouze primár, sekundár přebírá při výpadku.

> memfile je pro lab v pohodě – HA hook replikuje leasování mezi uzly.

> Když budeš chtít obsloužit DMZ (10.0.10.0/24), přidej na MikroTiku DHCP relay na obě IP:  
> /ip dhcp-relay add name=dmz-relay interface=dmz dhcp-server=10.0.20.11,10.0.20.12 local-address=10.0.10.254

5. Spuštění a povolení služeb

### Na OBOU uzlech:

````shell
sudo kea-dhcp4 -t /etc/kea/kea-dhcp4.conf     # validace
sudo kea-ctrl-agent -t /etc/kea/kea-ctrl-agent.conf

sudo systemctl enable --now kea-dhcp4-server
sudo systemctl enable --now kea-ctrl-agent
````



5) Ověření HA stavu
## Na AZ1:

````shell
sudo systemctl status kea-ctrl-agent
ss -lntp | grep 8000      # měl by naslouchat na 0.0.0.0:8000 nebo 10.0.20.x:8000


````


## Na AZ2:
````shell
echo '{ "command": "ha-status-get", "service": [ "dhcp4" ] }' | \
kea-shell -s http://10.0.20.12:8000/
````



>Uvidíš role primary/secondary a heartbeat.

## Failover test:
````shell
sudo systemctl stop kea-dhcp4-server na AZ1 #
# po pár sekundách by AZ2 měl přejít do role partner-down a začít odpovídat. Zase zapni AZ1 a stav se vrátí.
````

7. (Volitelné) Log level pro ladění

> Do obou kea-dhcp4.conf můžeš přidat:


````shell
"loggers": [
{ "name": "kea-dhcp4", "severity": "INFO", "output_options": [ { "output": "/var/log/kea/kea-dhcp4.log" } ] }
]
````



## Vytvořit adresář: 
````shell
sudo mkdir -p /var/log/kea && sudo chown kea:adm /var/log/kea.
````

