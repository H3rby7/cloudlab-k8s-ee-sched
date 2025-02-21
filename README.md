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
- [Developing](#developing)
  - [Changing your Kubernetes deployment](#changing-your-kubernetes-deployment)
  - [Cheatsheet](#cheatsheet)
    - [Git](#git)
    - [Changing helm deployments live](#changing-helm-deployments-live)
  - [Grafana Dashboard](#grafana-dashboard)
    - [Modify Grafana Dashboard](#modify-grafana-dashboard)
- [Limitations](#limitations)
- [Known issues](#known-issues)
- [Improvements](#improvements)

# Developing

## Changing your Kubernetes deployment

The profile's setup scripts are automatically installed on each node in `/local/repository`, and all of the Kubernetes installation is triggered from `node-0`.  The scripts execute as your uid, and keep state and downloaded files in `/local/setup/`.  The scripts write copious logfiles in that directory; so if you think there's a problem with the configuration, you could take a quick look through these logs on the `node-0` node.  The primary logfile is `/local/logs/setup.log`.

Kubespray is a collection of Ansible playbooks, so you can make changes to the deployed kubernetes cluster, or even destroy and rebuild it (although you would then lose any of the post-install configuration we do in `/local/repository/setup-kubernetes-extra.sh`).  The `/local/repository/setup-kubespray.sh` script installs Ansible inside a Python 3 `virtualenv` (in `/local/setup/kubespray-virtualenv` on `node-0`).  A `virtualenv` (or `venv`) is effectively a separate part of the filesystem containing Python libraries and scripts, and a set of environment variables and paths that restrict its user to those Python libraries and scripts.  To modify your cluster's configuration in the Kubespray/Ansible way, you can run commands like these (as your uid):

1. "Enter" (or access) the "virtualenv": `. /local/setup/kubespray-virtualenv/bin/activate`
2. Leave (or remove the environment vars from your shell session) the "virtualenv": `deactivate`
3. Destroy your entire kubernetes cluster: `ansible-playbook -i /local/setup/inventories/kubernetes/inventory.ini /local/setup/kubespray/remove-node.yml -b -v --extra-vars "node=node-0,node-1,node-2"`
   (note that you would want to supply the short names of all nodes in your experiment)
4. Recreate your kubernetes cluster: `ansible-playbook -i /local/setup/inventories/kubernetes/inventory.ini /local/setup/kubespray/cluster.yml -b -v`

To change the Ansible and playbook configuration, you can start reading Kubespray documentation:
  - https://github.com/kubernetes-sigs/kubespray/blob/master/docs/getting-started.md
  - https://github.com/kubernetes-sigs/kubespray
  - https://kubespray.io/

## Cheatsheet

### Git

adding +x permissions on windows git (for sh files)

   git update-index --chmod=+x setup-file.sh
   kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=<node-X>

### Changing helm deployments live

prometheus stack

   helm upgrade obs prometheus-community/kube-prometheus-stack --version 69.3.1 --namespace monitoring -f /local/repository/prometheus-values.yaml

## Grafana Dashboard

Deploys [custom dashboards](./custom-grafana-dashboards.yaml).

### Modify Grafana Dashboard

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
* Server type dropdown filtered by the servers taht support power readings
* calculate total CPU and Memory from node type