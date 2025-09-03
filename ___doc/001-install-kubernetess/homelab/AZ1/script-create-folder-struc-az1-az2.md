## AZ1 -AZ2
> ulož jako  'create_homelab.sh'  
> poté spusť 

````shell
chmod +x create_homelab.sh
sudo ./create_homelab.sh
````

````shell
#!/bin/bash

# hlavní složka
mkdir -p /srv/homelab

# configs
mkdir -p /srv/homelab/configs/{haproxy,keepalived,bind9,kea-dhcp,keycloak,prometheus,grafana}

# data
mkdir -p /srv/homelab/data/{postgres,mariadb,mongodb,nextcloud}

# logs
mkdir -p /srv/homelab/logs/{haproxy,grafana,prometheus}

# docker
mkdir -p /srv/homelab/docker/{monitoring,databases}
touch /srv/homelab/docker/monitoring/docker-compose.yml
touch /srv/homelab/docker/databases/docker-compose.yml

# k8s
mkdir -p /srv/homelab/k8s/{ingress,monitoring}

echo "Struktura byla úspěšně vytvořena v /srv/homelab/"

````
