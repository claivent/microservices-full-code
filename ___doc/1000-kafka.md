```shell
kubectl exec -it kafka-67756d58ff-5k6nd -n dev -- kafka-console-producer --broker-list kafka-service.dev.svc.cluster.local:9092 --topic orders
>test 1
>test 2
>exit

kubectl exec -it kafka-67756d58ff-5k6nd -n dev -- kafka-console-consumer --bootstrap-server kafka-service.dev.svc.cluster.local:9092 --topic orders --from-beginning
test 1
test 2
exit
```
