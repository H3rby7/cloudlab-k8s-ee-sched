# Cloudlab EE Scheduler Benchmarking Profile

Based on:  https://gitlab.flux.utah.edu/johnsond/k8s-profile

See ['kubeInstructions' of profile.py](profile.py).

# TODOs

1. Deploy and run muBench with default scheduler
   1. manually - CHECK
   2. automated (via dataset maybe?)
2. Export data from prometheus for analysis in Matlab

# Cheatsheet

adding +x permissions on windows git (for sh files)

   git update-index --chmod=+x setup-file.sh

## Grafana Dashboards

Export JSON from Web-GUI and minify using two regexp replacements onto the string:

`^\s+` with `<nothing>` and `\n` with `<nothing>`


# Known issues

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