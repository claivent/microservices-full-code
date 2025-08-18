Vytvoø nový token (zase: Zone ? DNS ? Edit, a jen pro zónu claivent.website)



curl "https://api.cloudflare.com/client/v4/user/tokens/verify" \
-H "Authorization: Bearer << vlož token z trezoru >>"

Vytvoø nový token (zase: Zone ? DNS ? Edit, a jen pro zónu claivent.website).

Token si hned zkopíruj a ulož do bezpeèného místa (napø. ~/.secrets/cloudflare.ini, ale klidnì i do správce hesel).
```
sudo mkdir -p /root/.secrets
sudo bash -c 'cat > /root/.secrets/cloudflare.ini <<EOF
dns_cloudflare_api_token = << vlož token z trezoru >>
EOF'
sudo chmod 600 /root/.secrets/cloudflare.ini
``` 


sudo apt-get update   
sudo apt-get install -y python3-certbot-dns-cloudflare  

                            
```shell
 sudo certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials /root/.secrets/cloudflare.ini \
  --dns-cloudflare-propagation-seconds 60 \
  -d welcome2.claivent.website \
  -d www.welcome2.claivent.website \
  --agree-tos -m claivent@gmail.com  -v
```

claivent@uu:/etc/haproxy$ sudo certbot certonly \
--dns-cloudflare \
--dns-cloudflare-credentials /root/.secrets/cloudflare.ini \
-d claivent.website -d *.claivent.website \
--agree-tos -m claivent@gmail.com \
--dns-cloudflare-propagation-seconds 120
  


````
#output
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/welcome2.claivent.website-0001/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/welcome2.claivent.website-0001/privkey.pem
This certificate expires on 2025-11-16.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.
````

po uspechu 
```shell
sudo bash -c 'cat /etc/letsencrypt/live/welcome2.claivent.website-0001/fullchain.pem \
              /etc/letsencrypt/live/welcome2.claivent.website-0001/privkey.pem \
              > /etc/ssl/private/welcomeapp.pem'
sudo systemctl restart haproxy

```

```
# Automatizuj post-hook (doporuèeno)
# A se PEM regeneruje po každé obnovì automaticky:

sudo bash -c 'cat > /etc/letsencrypt/renewal-hooks/deploy/10-haproxy-pem.sh <<EOF
#!/bin/bash
set -e
if [ "\$RENEWED_LINEAGE" = "/etc/letsencrypt/live/welcome2.claivent.website-0001" ]; then
  cat "\$RENEWED_LINEAGE/fullchain.pem" "\$RENEWED_LINEAGE/privkey.pem" > /etc/ssl/private/welcomeapp.pem
  systemctl reload haproxy
fi
# Pøidej další domény podle potøeby
EOF'
sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/10-haproxy-pem.sh
```

sudo certbot renew --dry-run