watch -n1 curl -s -o /dev/null -w "%{http_code}\n" https://gw.claivent.website/api/v1/customers


kubectl -n default exec -it  customer-service-59985b6b4b-zpn6s  -- wget -qO- http://localhost:8090/actuator/health
