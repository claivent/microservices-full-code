##  TAGGING AN IMAGE UNDER AN ADDITIONAL TAG

```bash
docker tag kiada claivent/kiada:0.1
```

```bash
docker login
```
```bash
docker push claivent/kiada:0.1
```

```bash
docker run --name kiada-container -p 1234:8080 -d claivent/kiada:0.1
```



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

minikube -p luksa-book addons enable dashboard  
