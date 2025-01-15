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
helm repo add ingress-nginx \
    https://kubernetes.github.io/ingress-nginx
helm repo update

# Create admin secret(s)
kubectl create secret generic grafana-admin --from-literal=admin-user=${ADMIN} --from-literal=admin-password=${ADMIN_PASS}

# Setup nginx
# https://kubernetes.github.io/ingress-nginx/

helm install nginx ingress-nginx/ingress-nginx --wait


# Setup prometheus stack for metric collection
# https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml

cat <<EOF >$OURDIR/prometheus-values.yaml
defaultRules:
  create: false
prometheus-windows-exporter:
  prometheus:
    monitor:
      enabled: false
alertmanager:
  enabled: false
grafana:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
    path: /grafana
  grafana.ini:
    server:
      root_url: "http://${PUBLICADDRS}/grafana/"
      serve_from_sub_path: true
  admin:
    existingSecret: grafana-admin
prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
prometheus-node-exporter:
  extraArgs:
    - --collector.filesystem.mount-points-exclude=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/.+)($|/)
    - --collector.filesystem.fs-types-exclude=^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$
    - --collector.textfile.directory=/text-collectors
  extraHostVolumeMounts:
    - name: text-collectors
      hostPath: /node-exporter-text-collectors
      mountPath: /text-collectors
      readOnly: true
EOF
helm install obs \
    prometheus-community/kube-prometheus-stack \
    -f $OURDIR/prometheus-values.yaml --wait


logtend "metrics"
touch $OURDIR/metrics-done
exit 0
