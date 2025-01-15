# TODOs

1. Export data from prometheus for analysis in Matlab
2. Ease and secure access to setup using https://kubernetes.github.io/ingress-nginx/deploy/:
   1. https://kubernetes.github.io/ingress-nginx/examples/auth/basic/
      1. prometheus
      2. grafana

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
