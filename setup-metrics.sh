#!/bin/sh

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/metrics-done ]; then
    exit 0
fi

logtstart "metrics"

# Add prometheus-community helm repo
helm repo add prometheus-community \
    https://prometheus-community.github.io/helm-charts
helm repo update


# Create admin secret(s)
kubectl create secret generic grafana-admin --from-literal=admin-user=${ADMIN} --from-literal=admin-password=${ADMIN_PASS}


# Setup prometheus stack for metric collection
# https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml

cat <<EOF >$OURDIR/prometheus-values.yaml
prometheus-windows-exporter:
  prometheus:
    monitor:
      enabled: false
alertmanager:
  enabled: false
grafana:
  service:
    type: LoadBalancer
  admin:
    existingSecret: grafana-admin
prometheus:
  service:
    type: LoadBalancer
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
EOF
helm install obs \
    prometheus-community/kube-prometheus-stack \
    -f $OURDIR/prometheus-values.yaml --wait


# Setup IPMI expoter to collect power data
# https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-ipmi-exporter/values.yaml
cat <<EOF >$OURDIR/ipmi-exporter-values.yaml
serviceMonitor:
  enabled: true
EOF
helm install ipmi \
    prometheus-community/prometheus-ipmi-exporter \
    -f $OURDIR/ipmi-exporter-values.yaml --wait


logtend "metrics"
touch $OURDIR/metrics-done
exit 0
