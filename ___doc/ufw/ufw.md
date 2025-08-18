4755  dpkg -l | grep ufw
4756  ufw status
4757  sudo ufw status
4758  sudo ufw reset
4759  sudo ufw allow 22/tcp
4760  dpkg -l | grep ufw
4761  sudo ufw allow 80/tcp     # HTTP
4762  sudo ufw allow 443/tcp    # HTTPS
4763  sudo ufw allow 2096/tcp   # pokud ho chceš zachovat pro testy
4764  sudo ufw status verbose
4765  sudo ufw enable
4766  sudo ufw status verbose
4767  history
