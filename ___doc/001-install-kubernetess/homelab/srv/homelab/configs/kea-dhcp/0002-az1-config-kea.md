
## /etc/kea/kea-dhcp4.conf

````json
{
  "interfaces-config": { "interfaces": [ "ens33" ] },
  "lease-database": { "type": "memfile", "persist": true, "name": "/var/lib/kea/kea-leases4.csv" },
  "valid-lifetime": 3600,
  "renew-timer": 900,
  "rebind-timer": 1800,
  "subnet4": [
    {
      "subnet": "10.0.20.0/24",
      "pools": [ { "pool": "10.0.20.100 - 10.0.20.199" } ],
      "option-data": [
        { "name": "routers", "data": "10.0.20.1" },
        { "name": "domain-name-servers", "data": "10.0.20.11,10.0.20.12" },
        { "name": "domain-name", "data": "lab.claivent.website" }
      ],
      "reservations": [
        { "hw-address": "00:0c:29:aa:59:4a", "ip-address": "10.0.20.11" },  
        { "hw-address": "00:0c:29:d7:c0:78", "ip-address": "10.0.20.12" }   
      ]
    }
  ]
}

````

````shell
sudo kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
sudo systemctl enable --now kea-dhcp4-server
````
