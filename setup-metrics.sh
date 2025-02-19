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

# Create secret for ingress BASIC AUTH
# Output file name must be 'auth' as this will be the KEY inside the secret
echo "$ADMIN_PASS" | htpasswd -n -i "$ADMIN" | tee -a auth
kubectl --namespace monitoring create secret generic ingress-basic-auth --from-file=auth
rm auth

# Setup prometheus stack for metric collection
helm install obs \
    prometheus-community/kube-prometheus-stack \
    --version 69.3.1 \
    --namespace monitoring \
    -f $REPODIR/prometheus-values.yaml \
    --wait

# Create configMap that will be detected and deployed by the grafana sidecar
kubectl create --namespace monitoring -f $REPODIR/custom-grafana-dashboards.yaml

tries=60
while [ $tries -gt 0 ]; do
    kubectl wait pod -n monitoring --for=condition=Ready --all
    if [ $? -eq 0 ]; then
	break
    else
	tries=`expr $tries - 1`
	echo "WARNING: waiting for monitoring pods to be Ready ($tries remaining)"
	sleep 5
    fi
done

logtend "metrics"
touch $OURDIR/metrics-done
exit 0
