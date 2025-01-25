#!/bin/sh

set -x

REPODIR=`dirname $0`

# Grab our libs
. "${REPODIR}/setup-lib.sh"

if [ -f $OURDIR/metrics-done ]; then
    exit 0
fi

logtstart "metrics"

# Add prometheus-community helm repo
helm repo add prometheus-community \
    https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx \
    https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace monitoring
kubectl create namespace nginx

# Create GRAFANA admin secret
kubectl --namespace monitoring create secret generic grafana-admin --from-literal=admin-user=${ADMIN} --from-literal=admin-password=${ADMIN_PASS}

# Create secret for ingress BASIC AUTH
# Output file name must be 'auth' as this will be the KEY inside the secret
echo "$ADMIN_PASS" | htpasswd -n -i "$ADMIN" | tee -a auth
kubectl --namespace monitoring create secret generic ingress-basic-auth --from-file=auth
rm auth

# Setup nginx
# https://kubernetes.github.io/ingress-nginx/

helm install nginx ingress-nginx/ingress-nginx --namespace nginx --wait

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
