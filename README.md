# TODOs

1. Test Profile rollout
2. Prometheus (+ Grafana)?
3. Export data from prometheus for analysis in Matlab
4. Ease and secure access to setup using https://kubernetes.github.io/ingress-nginx/deploy/:
   1. https://kubernetes.github.io/ingress-nginx/examples/auth/basic/
      1. prometheus
      2. grafana

## IPMI Changes

https://github.com/prometheus-community/node-exporter-textfile-collector-scripts?tab=readme-ov-file

    sudo apt-get install ipmitool
    sudo ipmitool sensor | grep Pwr
    sudo ipmitool user set name 3 moni
    sudo ipmitool user set password 3 kaaaaaaaaaaaaaaa
    sudo ipmitool user test 3 16
    sudo ipmitool channel setaccess 2 3 link=on ipmi=on callin=on privilege=2
    sudo ipmitool user enable 3
    sudo ipmitool channel getaccess 1 3
    sudo ipmitool lan print 1
    ipmitool -I lanplus -H 10.10.1.3 -U moni -P kaaaaaaaaaaaaaaa -A MD5 -vv sensor

### In container cmds

    ipmimonitoring -h 10.10.1.3 -vv

Potentially the monitoring query to get info:

    wget -O - localhost:9290/ipmi?target=10.10.1.3