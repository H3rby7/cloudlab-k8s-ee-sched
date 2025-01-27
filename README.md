# Cloudlab EE Scheduler Benchmarking Profile

Create a kubernetes cluster to benchmark schedulers with 
* the service-cell approach from [µBench](https://github.com/mSvcBench/muBench)
* Workload modeled from Alibaba 2022 microservice traces

Forked cloudlab-profile from:  https://gitlab.flux.utah.edu/johnsond/k8s-profile

See ['kubeInstructions' of profile.py](profile.py).

- [Cloudlab EE Scheduler Benchmarking Profile](#cloudlab-ee-scheduler-benchmarking-profile)
- [TODOs](#todos)
- [Cheatsheet](#cheatsheet)
- [Grafana Dashboard](#grafana-dashboard)
  - [Modify Grafana Dashboard](#modify-grafana-dashboard)
- [Known issues](#known-issues)
  - [Late Node Provisioning](#late-node-provisioning)
  - [Multiple results for power watts](#multiple-results-for-power-watts)

# TODOs

1. Deploy and run muBench with default scheduler
   1. manually - CHECK
   2. automated (via dataset maybe?)
2. Export data from prometheus for analysis in Matlab

# Cheatsheet

adding +x permissions on windows git (for sh files)

   git update-index --chmod=+x setup-file.sh
   kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=<node-X>

# Grafana Dashboard

Deploys [custom dashboards](./custom-grafana-dashboards.yaml).

## Modify Grafana Dashboard

Modify Grafana Dashboard in WEB-GUI, export JSON and minify the result string using two regexp replacements:

1. Replace `^\s+` with `''`
2. Replace `\n` with `''`
3. Wrap the resulting one-liner with single `'`quotes`'` and replace the data inside the yaml file.

# Known issues

## Late Node Provisioning

Behavior MAY already be fixed through a wait-script:

In rare cases nodes may be provided too late for the automatic setup scripts on node-0 to run.

In those cases it is possible to run the ansible script manually as described in the `profile instructions`.

*NOTE: When manually running the script it may stop and intransparently prompt you to enter 'yes' (x times) to add the now discovered hosts to your trusted list*

## Multiple results for power watts

if using that cloudlab, else - less relevant.

For wisconsing cloudlab:

```
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.3:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.3", node_name="node-2", pod="obs-prometheus-node-exporter-jtrlk", sensor="POWER_USAGE", service="obs-prometheus-node-exporter"}	126
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.3:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.3", node_name="node-2", pod="obs-prometheus-node-exporter-jtrlk", sensor="PSU1_PIN", service="obs-prometheus-node-exporter"}	128
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.3:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.3", node_name="node-2", pod="obs-prometheus-node-exporter-jtrlk", sensor="PSU1_POUT", service="obs-prometheus-node-exporter"}	112
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.1:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.1", node_name="node-0", pod="obs-prometheus-node-exporter-7bwq8", sensor="POWER_USAGE", service="obs-prometheus-node-exporter"}	126
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.1:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.1", node_name="node-0", pod="obs-prometheus-node-exporter-7bwq8", sensor="PSU1_PIN", service="obs-prometheus-node-exporter"}	128
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.1:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.1", node_name="node-0", pod="obs-prometheus-node-exporter-7bwq8", sensor="PSU1_POUT", service="obs-prometheus-node-exporter"}	112
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.2:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.2", node_name="node-1", pod="obs-prometheus-node-exporter-v2rcc", sensor="POWER_USAGE", service="obs-prometheus-node-exporter"}	126
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.2:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.2", node_name="node-1", pod="obs-prometheus-node-exporter-v2rcc", sensor="PSU1_PIN", service="obs-prometheus-node-exporter"}	128
node_ipmi_power_watts{container="node-exporter", endpoint="http-metrics", instance="10.10.1.2:9100", job="node-exporter", namespace="monitoring", node_ip="10.10.1.2", node_name="node-1", pod="obs-prometheus-node-exporter-v2rcc", sensor="PSU1_POUT", service="obs-prometheus-node-exporter"}
```