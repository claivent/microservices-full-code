#!/bin/bash

echo "✅ Spouštím port-forward pro služby..."
echo

# Kafka
echo Kafka
kubectl port-forward svc/kafka-service 9092:9092 &

# Kafka UI
echo Kafka UI
kubectl port-forward svc/kafka-ui 8080:80 &

# MailDev (web + SMTP)
echo MailDev
kubectl port-forward svc/mail-dev 1080:1080 &  # Web UI
kubectl port-forward svc/mail-dev 1025:1025 &  # SMTP

# Mongo Express
echo Mongo Express
kubectl port-forward svc/mongo-express 8150:8150 &

# pgAdmin

kubectl port-forward svc/pgadmin 8290:8190 &

# Zipkin
echo Zipkin
kubectl port-forward svc/zipkin 9411:9411 &

#config-server
echo Config Server

kubectl port-forward svc/config-server 8888:8888 &

#discovery-server
echo Discovery Server
kubectl port-forward svc/discovery-service 8761:8761 &

# product service
echo Product Service
kubectl port-forward svc/product-service 8050:8050 &

# customer-service
echo Customer Service
kubectl port-forward svc/customer-service 8090:8090 &

# payment-service
echo Payment Service
kubectl port-forward svc/payment-service 8060:8060 &

# order-service
echo Order Service
kubectl port-forward svc/order-service 8070:8070 &

# notification-service
echo Notification Service
kubectl port-forward svc/notification-service 8040:8040 &

#gateway-service
echo Gateway Service
kubectl port-forward svc/gateway-service 8222:8222 &


echo "🎯 Všechny porty přesměrovány. Použij CTRL+C pro ukončení."
wait
