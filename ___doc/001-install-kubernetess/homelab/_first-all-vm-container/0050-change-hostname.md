````shell
 cat /etc/hostname
````
> change name to AZ1

````shell
sudo hostnamectl set-hostname "AZ1"
````

````shell
echo 'AZ1' > /proc/sys/kernel/hostname # je jen pro čtení neprojde
cat  /proc/sys/kernel/hostname # zkontroluj
````

