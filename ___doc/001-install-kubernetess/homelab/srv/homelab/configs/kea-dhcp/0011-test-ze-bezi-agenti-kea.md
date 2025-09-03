Ověř, že běží Control Agent (na AZ1 i AZ2):

sudo systemctl status kea-ctrl-agent
ss -lntp | grep 8000      # měl by naslouchat na 0.0.0.0:8000 nebo 10.0.20.x:8000



Vyzkoušej API:

curl -s http://10.0.20.11:8000/ \
-H 'Content-Type: application/json' \
-d '{ "command": "list-commands" }' | jq .

curl -s http://10.0.20.11:8000/ \
-H 'Content-Type: application/json' \
-d '{ "command":"list-commands", "service":["dhcp4"] }' | jq .



(pokud nemáš jq, nainstaluj sudo apt install -y jq, nebo vynech | jq .)

HA stav (nahrazuje kea-shell ... ha-status-get):

curl -s http://10.0.20.11:8000/ \
-H 'Content-Type: application/json' \
-d '{ "command": "status-get", "service": [ "dhcp4" ] }' | jq .


Reload konfigurace:

curl -s http://10.0.20.11:8000/ \
-H 'Content-Type: application/json' \
-d '{ "command": "config-reload", "service": [ "dhcp4" ] }' | jq .


Kontrola lease (příklad):

# podle IP
curl -s http://10.0.20.11:8000/ \
-H 'Content-Type: application/json' \
-d '{ "command": "lease4-get", "arguments": { "ip-address": "10.0.20.198" } }' | jq .

# posledních N lease
curl -s http://10.0.20.11:8000/ \
-H 'Content-Type: application/json' \
-d '{ "command": "lease4-get-all", "arguments": { "from": 0, "limit": 20 } }' | jq .


Pokud se příkaz nevrací: zkontroluj, že v kea-ctrl-agent.conf je http-host nastaven na správnou IP (10.0.20.11/12) a že v kea-dhcp4.conf máš control-socket:

"control-socket": { "socket-type": "unix", "socket-name": "/run/kea/kea4-ctrl-socket" }
