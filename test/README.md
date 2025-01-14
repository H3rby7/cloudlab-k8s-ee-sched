# Test

utilities to test helm and kubectl related commands locally within docker-compose.

    docker-compose up -d

    docker-compose exec helm bash

## Prometheus Stack

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

    helm repo update

    helm template prometheus-community/kube-prometheus-stack -f prometheus-values.yaml > prometheus-stack.yaml

## Kubectl Tests

Install kubectl (required once):

    apk add kubectl

Test creating secret

    kubectl create secret generic grafana-admin --from-literal=admin-user=user1 --from-literal=admin-password=pwd1 --dry-run=client -o yaml

    echo dmFsdWUx | base64 -d
