# Cloudlab EE Scheduler Benchmarking Profile

Create a kubernetes cluster to benchmark schedulers with 
* the service-cell approach from [µBench](https://github.com/mSvcBench/muBench)
* Workload modeled from Alibaba 2022 microservice traces

Forked cloudlab-profile from:  https://gitlab.flux.utah.edu/johnsond/k8s-profile

See ['kubeInstructions' of profile.py](profile.py).

Cluster contents:

Nodename   | Purpose
---        | ---
node-0     | control_plane and sets up Kubernetes
node-1     | control_plane
node-2     | observer (hosts everything that belongs to a worker node and ist not a service-cell)
node-3 ... | benchmarking (only runs required daemonsets and service-cells)

- [Cloudlab EE Scheduler Benchmarking Profile](#cloudlab-ee-scheduler-benchmarking-profile)
- [TODOs](#todos)
- [Cheatsheet](#cheatsheet)
- [Grafana Dashboard](#grafana-dashboard)
  - [Modify Grafana Dashboard](#modify-grafana-dashboard)
- [Limitations](#limitations)
- [Known issues](#known-issues)
- [Improvements](#improvements)

# TODOs

1. Deploy and run muBench with default scheduler
   1. manually - CHECK
   2. automated (via dataset maybe?)
2. Export data from prometheus to file for analysis in Matlab

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

# Limitations

* Node restart seems to be unsupported with the setup

# Known issues

# Improvements

* examine: can we remove 'nginx-proxy' pods on benchmark nodes (since we do not necessarily need to route to ingresses there?)
* Push CSV-Runner logs to Grafana via LOKI