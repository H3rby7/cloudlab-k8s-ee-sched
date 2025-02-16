#!/bin/sh

set -x

REPODIR=`dirname $0`

# Grab our libs
. "${REPODIR}/setup-lib.sh"

if [ -f $OURDIR/metrics-done ]; then
    exit 0
fi

logtstart "metrics"

# Add helm repo
helm repo add prometheus-community \
    https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

# Create GRAFANA admin secret
kubectl --namespace monitoring create secret generic grafana-admin --from-literal=admin-user=${ADMIN} --from-literal=admin-password=${ADMIN_PASS}

# Setup prometheus stack for metric collection
helm install obs \
    prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    -f $REPODIR/prometheus-values.yaml --wait

# Create configMap that will be detected and deployed by the grafana sidecar
kubectl create --namespace monitoring -f $REPODIR/custom-grafana-dashboards.yaml

logtend "metrics"
touch $OURDIR/metrics-done
exit 0
