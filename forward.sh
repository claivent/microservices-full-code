#!/bin/bash

echo "✅ Spouštím port-forward pro služby..."
echo

# Kafka
kubectl port-forward svc/kafka-service 9092:9092 &

# Kafka UI
kubectl port-forward svc/kafka-ui 8080:80 &

# MailDev (web + SMTP)
kubectl port-forward svc/mail-dev 1080:1080 &  # Web UI
kubectl port-forward svc/mail-dev 1025:1025 &  # SMTP

# Mongo Express
kubectl port-forward svc/mongo-express 8081:8081 &

# pgAdmin
kubectl port-forward svc/pgadmin 8190:8190 &

# Zipkin
kubectl port-forward svc/zipkin 9411:9411 &

#config-server

kubectl port-forward svc/config-server 8888:8888 &

#discovery-server
kubectl port-forward svc/discovery-service 8761:8761 &

echo "🎯 Všechny porty přesměrovány. Použij CTRL+C pro ukončení."
wait
