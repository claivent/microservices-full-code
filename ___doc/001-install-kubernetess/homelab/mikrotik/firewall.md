````shell
/ip firewall filter
add chain=forward src-address=10.0.10.0/24 dst-address=10.0.20.11 protocol=udp dst-port=53 action=accept comment="DMZ->AZ1 DNS"
add chain=forward src-address=10.0.10.0/24 dst-address=10.0.20.11 protocol=tcp dst-port=53 action=accept
add chain=forward src-address=10.0.10.0/24 dst-address=10.0.20.12 protocol=udp dst-port=53 action=accept comment="DMZ->AZ2 DNS"
add chain=forward src-address=10.0.10.0/24 dst-address=10.0.20.12 protocol=tcp dst-port=53 action=accept

````
