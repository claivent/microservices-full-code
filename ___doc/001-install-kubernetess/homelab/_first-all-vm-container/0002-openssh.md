````shell
sudo apt update
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
sudo systemctl status ssh   # ověř, že běží (Active: active)
````

````shell
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo vim /etc/ssh/sshd_config
````
```` 
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication yes   # nech zapnuté pro první přihlášení; pak můžeš přepnout na no

````

````shell
sudo systemctl restart ssh

````

## C) Firewall (pokud používáš UFW)

````shell
sudo ufw allow OpenSSH
sudo ufw enable        # jen pokud ještě není zapnutý
sudo ufw status

````

> IP adresa VM: ověř ip -4 addr (LB1 bude třeba 10.0.10.11, AZ1 10.0.20.11 atd.).

## Na Windows (PuTTY / PuTTYgen)
###   A) První přihlášení (heslem)

Otevři PuTTY.

> Host Name: IP VM (např. 10.0.10.11 pro LB1, 10.0.20.11 pro AZ1).  
> Port: 22, Connection type: SSH → Open.  
> Přihlas se uživatelem (např. ubuntu/tvůj účet) a heslem.

### B) Přihlášení přes klíče (doporučeno)

> Spusť PuTTYgen → Generate → hýbej myší, až se klíč vygeneruje.  
> Save private key (formát .ppk) – ulož na bezpečné místo.  
> Zkopíruj public key (ten text nahoře, začíná ssh-rsa nebo ssh-ed25519).  
> 

### Na Ubuntu VM vytvoř soubor s klíčem:
````shell
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
# vlož sem veřejný klíč z PuTTYgen (celý řádek)
chmod 600 ~/.ssh/authorized_keys

````

>V PuTTY: Connection → SSH → Auth → “Browse…” → vyber .ppk → připoj se.  
> Až ověříš, že klíče fungují, můžeš v /etc/ssh/sshd_config nastavit:  


>PasswordAuthentication no


>a sudo systemctl restart ssh. 
> 
