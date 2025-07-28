# Strimzi Kafka KRaft-only Setup in Minikube

## Steps

1. Create the namespace and install Strimzi:

```bash
bash strimzi-install.sh
```

2. Apply the Kafka KRaft cluster:

```bash
kubectl apply -f kafka-cluster-kraft.yaml
```

3. Create a topic:

```bash
kubectl apply -f sample-topic.yaml
```

4. Verify the pods:

```bash
kubectl get pods -n dev
```

5. Connect with your Kafka clients to `my-kafka-cluster-kafka-bootstrap.dev:9092` (internal access).