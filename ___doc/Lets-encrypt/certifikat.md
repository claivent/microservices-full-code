```
#výpis z haproxy 

# ? HTTPS port ((loudflare > 2096))
frontend welcomeapp_https
    bind *:2096 ssl crt /etc/ssl/private/welcomeapp.pem
    mode http                                                                                                                                                       
    http-request capture hdr(host) len 40                                                                                                                           
    acl host_welcome_ssl hdr(host) -i welcome2.claivent.website www.welcome2.claivent.website welcome2.claivent.website:2096 www.welcome2.claivent.website:2096     
    use_backend welcomeapp_backend if host_welcome_ssl                                                                                                              
    default_backend fallback_backend                                                                                                                                
                                                                                                                                                                    
# ? Backendy – sdílené pro oba frontendy                                                                                                                           
backend welcomeapp_backend                                                                                                                                          
    mode http                                                                                                                                                       
    balance roundrobin                                                                                                                                              
    server w1 192.168.100.113:30082 check ssl verify none                                                                                                           
    server w2 192.168.100.114:30082 check ssl verify none 
```
sudo certbot renew --force-renewal
