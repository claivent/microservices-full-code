1. Vytvořeny vmware AZ1, AZ2, LB1, LB2
   1. vytvořeny adresy a sítě v mikrotik a statické adresy na servrech 
      1. DMZ 10.0.10.0/24
      2  lb1: 10.0.10.11
      3. lb2: 10.0.10.12
      4. VIP (VRRP): 10.0.10.9
      5. LAN 10.0.20.0/24
      6. az1: 10.0.20.11
      7. az2: 10.0.20.12
   2. RouterOS
      1. WAN (VMnet0): DHCP z domácí sítě
      2. DMZ (VMnet2): 10.0.10.1/24
      3. LAN (VMnet3): 10.0.20.1/24
      4. (SYNC: 10.0.30.1/24)
2. Change netplan ALL-vmware-kontainer
3. Instalován openssh-server
4. Změnil jsem Machineid všech kontejnerů 
5. Změnil jsem hostname
6. Instalovány package do kontejnerů
   1. > sudo apt install vim nano jq inetutils-ping net-tools git curl wget htop
7. Vytvořeny všechny konfugurace v mikrotiku.
   1. ping mezi kontejnery OK
   2. ping do internetu OK ze všech kontejnerů
8. Nainstalován tree package do ALL-Kontejner.
   1. ````shell
      sudo apt-get install tree
      ````
   
