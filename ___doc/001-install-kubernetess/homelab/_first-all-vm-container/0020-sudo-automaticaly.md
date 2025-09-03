````shell
sudo echo "== [1] Umožňuji sudo bez hesla pro uživatele claivent =="
sudo visudo  /etc/sudoers
````
> Bez uvozovek vlož do sekce za root.  
>"claivent ALL=(ALL) NOPASSWD: ALL"
