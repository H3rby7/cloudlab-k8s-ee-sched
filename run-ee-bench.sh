#!/bin/sh

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/run-ee-bench-done ]; then
    echo "run-ee-bench already ran; not running again"
    exit 0
fi

logtstart "ee-bench"

echo "Adding helm repository"

helm repo add ee-sched https://h3rby7.github.io/cloudlab-k8s-ee-sched-helm
helm repo update

echo "Creating helm values file"

scheduler=`awk -F'[<>]' '$0 ~ /name="emulab.net.parameter.benchmarkScheduler"/ {print $3}' $OURDIR/manifests.0.xml`
benchmark_node_count=`awk -F'[<>]' '$0 ~ /name="emulab.net.parameter.benchmarkNodeCount"/ {print $3}' $OURDIR/manifests.0.xml`
total_cpu=`awk -F'[<>]' '$0 ~ /name="emulab.net.parameter.totalCPU"/ {print $3}' $OURDIR/manifests.0.xml`
total_memory=`awk -F'[<>]' '$0 ~ /name="emulab.net.parameter.totalMEMORY"/ {print $3}' $OURDIR/manifests.0.xml`
set_limits=`awk -F'[<>]' '$0 ~ /name="emulab.net.parameter.setResourceLimits"/ {print $3}' $OURDIR/manifests.0.xml`

cat <<EOF > $OURDIR/custom-helm-values.yaml
resources:
  cluster:
    node_count: $benchmark_node_count
    nodes_total_cpu_cores: $total_cpu
    nodes_total_memory_mbytes: $total_memory
  service_cell:
    set_resource_limits: $set_limits
benchmark:
  scheduler: $scheduler
EOF

echo "****************** Custom HELM values ******************"
cat $OURDIR/custom-helm-values.yaml
echo "****************** end HELM values ******************"

helm install cl-exp ee-sched/cloud-ee-bench -f $OURDIR/custom-helm-values.yaml

logtend "ee-bench"

touch $OURDIR/run-ee-bench-done

exit 0
