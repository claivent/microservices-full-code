global
    log /dev/log    local0
    log /dev/log    local1 notice
    daemon
    maxconn 2048

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5s
    timeout client  50s
    timeout server  50s

# ✅ Kubernetes API TCP forward (beze změny)
frontend k8s_api
    bind *:6443
    mode tcp
    default_backend k8s_api_backend

backend k8s_api_backend
    mode tcp
    balance roundrobin
    option tcp-check
    server cp1 192.168.100.111:6443 check
    server cp2 192.168.100.112:6443 check backup

# ✅ HTTP port (Cloudflare > 2052)
frontend welcomeapp_http
    bind welcome2.claivent.website:2052
    mode http
    acl host_welcome hdr(host) -i welcome2.claivent.website www.welcome2.claivent.website welcome2.claivent.website:2052 www.welcome2.claivent.website:2052
    acl host_express hdr(host) -i express.claivent.website www.express.claivent.website express.claivent.website:2052 www.express.claivent.website:2052
    acl host_customer hdr(host) -i customer.claivent.website www.customer.claivent.website customer.claivent.website:2052 www.customer.claivent.website:2052
    acl host_discovery hdr(host) -i discovery.claivent.website www.discovery.claivent.website discovery.claivent.website:2052 www.discovery.claivent.website:2052
    acl host_gw hdr(host) -i gw.claivent.website www.gw.claivent.website gw.claivent.website:2052 www.gw.claivent.website:2052
    use_backend welcomeapp_backend if host_welcome
    use_backend expressapp_backend if host_express
    use_backend customerapp_backend if host_customer
    use_backend discoveryapp_backend if host_discovery
    use_backend gwapp_backend if host_gw
    default_backend fallback_backend

# ✅ HTTPS port (Cloudflare > 2096)
frontend welcomeapp_https
    bind *:2096 ssl crt /etc/ssl/private/welcomeapp.pem
    mode http
    http-request capture hdr(host) len 40
    acl host_welcome_ssl hdr(host) -i welcome2.claivent.website www.welcome2.claivent.website welcome2.claivent.website:2096 www.welcome2.claivent.website:2096
    use_backend welcomeapp_backend if host_welcome_ssl
    default_backend fallback_backend

# 🔁 Backendy – sdílené pro oba frontendy
backend welcomeapp_backend
    mode http
    balance roundrobin
    server w1 192.168.100.113:30082 check ssl verify none
    server w2 192.168.100.114:30082 check ssl verify none

backend expressapp_backend
    mode http
    balance roundrobin
    server w1 192.168.100.113:30083
    server w2 192.168.100.114:30083

backend customerapp_backend
    mode http
    balance roundrobin
    server w1 192.168.100.113:30090
    server w2 192.168.100.114:30090

backend discoveryapp_backend
    mode http
    balance roundrobin
    server w1 192.168.100.113:30091
    server w2 192.168.100.114:30091

backend gwapp_backend
    mode http
    balance roundrobin
    server w1 192.168.100.113:30092
    server w2 192.168.100.114:30092


backend fallback_backend
    mode http
    errorfile 503 /etc/haproxy/errors/503.http
#    balance roundrobin
#    server w1 192.168.100.113:30082 check
#    server w2 192.168.100.114:30082 check
