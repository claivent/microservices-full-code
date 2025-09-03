# AZ1 (LAN/VMnet3):


````yaml
# /etc/netplan/01-lan.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses: [10.0.20.11/24]
      routes:
        - to: default
          via: 10.0.20.254
      nameservers:
        addresses: [10.0.20.254,1.1.1.1]
````

```shell 
sudo tee /etc/netplan/50-cloud-init.yaml > /dev/null <<EOF
network:
  version: 2
  ethernets:
    eth0:
      addresses: [10.0.20.11/24]
      routes:
        - to: default
          via: 10.0.20.254
      nameservers:
        addresses: [10.0.20.254,1.1.1.1]
EOF
````
