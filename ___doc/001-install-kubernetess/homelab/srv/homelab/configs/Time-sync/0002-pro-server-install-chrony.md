sudo apt update  
sudo apt install chrony  

sudo nano /etc/chrony/chrony.conf  

>přidej chrony pokud nejsou  

````
pool ntp.ubuntu.com        iburst maxsources 4  
pool 0.ubuntu.pool.ntp.org iburst maxsources 1  
pool 1.ubuntu.pool.ntp.org iburst maxsources 1  
pool 2.ubuntu.pool.ntp.org iburst maxsources 2  

````

sudo systemctl enable chrony --now  


chronyc tracking  
chronyc sources -v  

