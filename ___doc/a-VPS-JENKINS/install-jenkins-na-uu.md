# Rychlé nasazení na uu (Docker Compose)

```
sudo mkdir -p /srv/jenkins
cd /srv/jenkins
```

### docker-compose.yml  
```yaml
version: "3.8"
services:
  jenkins:
    image: jenkins/jenkins:lts-jdk17
    container_name: jenkins
    restart: unless-stopped
    ports:
      - "8080:8080"     # web UI
      - "50000:50000"   # JNLP agenty (nech klidně tak)
    environment:
      - TZ=Europe/Prague
    user: "1000:1000"   # tvůj uid:gid
    volumes:
      - jenkins_home:/var/jenkins_home
      # až budeš stavět Docker image v pipeline, přidej:
      # - /var/run/docker.sock:/var/run/docker.sock
volumes:
  jenkins_home:

```

### docker compose up -d

```shell
claivent@uu:/srv/jenkins$ docker compose up -d
WARN[0000] /srv/jenkins/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 13/13
 ✔ jenkins Pulled                                                                                                                                                                                      9.7s 
   ✔ ebed137c7c18 Pull complete                                                                                                                                                                        3.4s 
   ✔ a16eed992861 Pull complete                                                                                                                                                                        5.4s 
   ✔ d0340747bfc5 Pull complete                                                                                                                                                                        5.6s 
   ✔ b3198e29cbc4 Pull complete                                                                                                                                                                        6.2s 
   ✔ 9fa62d58a0db Pull complete                                                                                                                                                                        6.2s 
   ✔ 31a9a2be77c3 Pull complete                                                                                                                                                                        6.7s 
   ✔ 3cd347526f2b Pull complete                                                                                                                                                                        6.7s 
   ✔ 654460caae81 Pull complete                                                                                                                                                                        6.8s 
   ✔ 5409b7785d28 Pull complete                                                                                                                                                                        7.3s 
   ✔ eacb50e9764c Pull complete                                                                                                                                                                        7.4s 
   ✔ cde67193d9e1 Pull complete                                                                                                                                                                        7.4s 
   ✔ d136c61ff867 Pull complete                                                                                                                                                                        7.4s 
[+] Running 3/3
 ✔ Network jenkins_default        Created                                                                                                                                                              0.1s 
 ✔ Volume "jenkins_jenkins_home"  Created                                                                                                                                                              0.0s 
 ✔ Container jenkins              Started

```
```shell
claivent@uu:~$ docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
b3a26f713a894005b57ec31135225887
```



