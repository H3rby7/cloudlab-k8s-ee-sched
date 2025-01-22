# Cloudlab EE Scheduler Benchmarking Profile



Based on:  https://gitlab.flux.utah.edu/johnsond/k8s-profile

# TODOs

1. Deploy and run muBench with default scheduler
2. Prometheus target that exposes pod metrics
   1. to get proper requests/limits values for the mubench cell
3. Node-Exporter IPMI scrape interval to 10s (from 30s default)
4. Export data from prometheus for analysis in Matlab
5. create serviceMonitor for muBench service cells (so prometheus can scrape their metrics)

# Cheatsheet

adding +x permissions on windows git (for sh files)

    git update-index --chmod=+x setup-file.sh

## IPMI Changes

    sudo apt-get install -y ipmitool moreutils
    sudo mkdir -p /node-exporter-text-collectors
    sudo chmod 777 /node-exporter-text-collectors
    wget -O ipmi2prom https://github.com/prometheus-community/node-exporter-textfile-collector-scripts/raw/4098ef9ba573cd5ac20e01d63d1586925348a4ac/ipmitool
    chmod +x ipmi2prom
    sudo mv ipmi2prom /usr/bin/ipmi2prom
    sudo ipmitool sensor | grep Pwr | ipmi2prom | sponge /node-exporter-text-collectors/ipmi.prom
