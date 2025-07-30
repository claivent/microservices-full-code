docker run busybox echo "Hello world"  

docker build -t kiada .  

```bash
docker run --name kiada-container -p 1234:8080 -d kiada
```
```bash
docker inspect kiada-container
```
```bash
docker logs kiada-container
```


```bash
docker ps
docker ps -a
```

```bash
docker exec -it kiada-container bash
```
- -i, which makes sure STDIN is kept open. You need this for entering commands into the shell.  
- -t, which allocates a pseudo terminal (TTY).

```bash
# uvnitř kontejneru
ps aux
```

```bash
# v hostitelském os 

ps aux
```

```bash
# v hostitelském os 

 ps aux | grep app.js
```

```bash
docker stop kiada-container
```