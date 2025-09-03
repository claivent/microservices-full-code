# Bind9 (DNS)
## AZ1 primární

````shell
sudo apt update
sudo apt install -y bind9 bind9-utils bind9-dnsutils
sudo mkdir -p /etc/bind/zones

````
### /etc/bind/named.conf.options
````
options {
  directory "/var/cache/bind";
  recursion yes;
  allow-query { 10.0.10.0/24; 10.0.20.0/24; };
  allow-recursion { 10.0.10.0/24; 10.0.20.0/24; };
  dnssec-validation yes;
  listen-on { any; };
  listen-on-v6 { none; };
  forwarders { 1.1.1.1; 8.8.8.8; };
};
````

### /etc/bind/named.conf.local
````
zone "lab.claivent.website" {
  type master;
  file "/etc/bind/zones/db.lab.claivent.website";
  allow-transfer { 10.0.20.12; };    // AZ2 sekundární DNS
};

````

### /etc/bind/zones/db.lab.claivent.website
```` 
$TTL 300
@   IN SOA dns1.lab.claivent.website. hostmaster.lab.claivent.website. (
        1   60   30   604800   300 )
    IN NS  dns1.lab.claivent.website.
    IN NS  dns2.lab.claivent.website.

dns1    IN A 10.0.20.11
dns2    IN A 10.0.20.12
router  IN A 10.0.20.1
lb1     IN A 10.0.10.11
lb2     IN A 10.0.10.12
vip     IN A 10.0.10.9
az1     IN A 10.0.20.11
az2     IN A 10.0.20.12

````


## AZ2 sekundární

````shell
sudo apt update
sudo apt install -y bind9 bind9-utils bind9-dnsutils

````

### /etc/bind/named.conf.options → stejný jako na AZ1.


### /etc/bind/named.conf.local

```` 
zone "lab.claivent.website" {
  type secondary;
  masters { 10.0.20.11; };
  file "/var/cache/bind/slave.db.lab.claivent.website";
};

````

````shell
sudo named-checkconf
sudo systemctl enable --now named

````






