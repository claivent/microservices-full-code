#!/bin/bash
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f https://strimzi.io/install/latest?namespace=dev