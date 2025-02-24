#!/bin/sh

##
## Setup ipmi for node-exporter
##

set -x

if [ -z "$EUID" ]; then
    EUID=`id -u`
fi

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/setup-ipmi-$EUID-done ]; then
    echo "setup-ipmi-$EUID already ran; not running again"
    exit 0
fi

logtstart "ipmi-$EUID"

$SUDO apt-get install -y ipmitool=1.8.18-11ubuntu2.1 moreutils=0.66-1
$SUDO mkdir -p /node-exporter-text-collectors
$SUDO chmod 777 /node-exporter-text-collectors
$SUDO wget -O ipmi2prom https://github.com/prometheus-community/node-exporter-textfile-collector-scripts/raw/4098ef9ba573cd5ac20e01d63d1586925348a4ac/ipmitool
$SUDO chmod +x ipmi2prom
$SUDO mv ipmi2prom /usr/bin/ipmi2prom

# Create a service to run ipmi
cat <<'EOF' | $SUDO tee /etc/systemd/system/ipmi.service
[Unit]
Description=Update IPMI readings

[Service]
Type=simple
Restart=always
User=root
ExecStart=/bin/sh -c "ipmitool sensor | ipmi2prom | sponge /node-exporter-text-collectors/ipmi.prom"
StandardOutput=journal+console
StandardError=journal+console

[Install]
WantedBy=multi-user.target
EOF

# Create a timer to trigger our IPMI service
cat <<'EOF' | $SUDO tee /etc/systemd/system/ipmi.timer
[Unit]
Description=Run ipmi.service every 10 seconds

[Timer]
OnBootSec=5s
OnUnitActiveSec=5s
AccuracySec=1s

[Install]
WantedBy=timers.target
EOF
$SUDO systemctl daemon-reload
$SUDO systemctl enable --now ipmi.timer

logtend "ipmi-$EUID"

touch $OURDIR/setup-ipmi-$EUID-done

exit 0
