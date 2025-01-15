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

apt-get install -y ipmitool moreutils
mkdir -p /node-exporter-text-collectors
chmod 777 /node-exporter-text-collectors
wget -O ipmi2prom https://github.com/prometheus-community/node-exporter-textfile-collector-scripts/raw/4098ef9ba573cd5ac20e01d63d1586925348a4ac/ipmitool
chmod +x ipmi2prom
mv ipmi2prom /usr/bin/ipmi2prom

# Create a service to run ipmi
cat <<'EOF' | $SUDO tee /etc/systemd/system/ipmi.service
[Unit]
Description=Update IPMI readings

[Service]
Type=simple
Restart=always
User=root
ExecStart=/bin/sh -c "ipmitool sensor | grep Pwr | ipmi2prom | sponge /node-exporter-text-collectors/ipmi.prom"
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
OnBootSec=10s
OnUnitActiveSec=10s
AccuracySec=1s

[Install]
WantedBy=timers.target
EOF
systemctl daemon-reload
systemctl enable --now my_command.timer

logtend "ipmi-$EUID"

touch $OURDIR/setup-ipmi-$EUID-done

exit 0
