#!/bin/bash

set -x

# Preserve legacy main logfile location
ln -s /local/logs/setup.log /local/setup/setup-driver.log

ALLNODESCRIPTS="setup-ssh.sh setup-disk-space.sh setup-ipmi.sh"
HEADNODESCRIPTS="setup-kubespray.sh setup-kubernetes-extra.sh setup-ingress-controller.sh setup-metrics.sh setup-custom-scheduler.sh run-ee-bench.sh setup-end.sh"
OBSERVERNODESCRIPTS="setup-dataset.sh setup-functions.sh"
WORKERNODESCRIPTS=""

export SRC=`dirname $0`
cd $SRC
. $SRC/setup-lib.sh

wait_for_all_nodes() {
	echo "Waiting for all nodes to become reachable [$NODEIPS]"
	ip_list=($NODEIPS)
	while :; do
		all_reachable=true
		for ip in "${ip_list[@]}"; do
			if ! ping -c 1 -W 1 "$ip" &> /dev/null; then
				echo "Waiting for $ip to become reachable..."
				all_reachable=false
			fi
		done
		if $all_reachable; then
			echo "All IPs are reachable!"
			break
		fi
		sleep 5
  done
}

# Don't run setup-driver.sh twice
if [ -f $OURDIR/setup-driver-done ]; then
    echo "setup-driver already ran; not running again"
    exit 0
fi
for script in $ALLNODESCRIPTS ; do
    cd $SRC
    $SRC/$script | tee - /local/logs/${script}.log 2>&1
    if [ ! $PIPESTATUS -eq 0 ]; then
	echo "ERROR: ${script} failed; aborting driver!"
	exit 1
    fi
done
if [ "$HOSTNAME" = "node-0" ]; then
		# node-0 needs other nodes to be ready, so we wait.
		wait_for_all_nodes
    for script in $HEADNODESCRIPTS ; do
	cd $SRC
	$SRC/$script | tee - /local/logs/${script}.log 2>&1
	if [ ! $PIPESTATUS -eq 0 ]; then
	    echo "ERROR: ${script} failed; aborting driver!"
	    exit 1
	fi
    done
else
    for script in $WORKERNODESCRIPTS ; do
	cd $SRC
	$SRC/$script | tee - /local/logs/${script}.log 2>&1
	if [ ! $PIPESTATUS -eq 0 ]; then
	    echo "ERROR: ${script} failed; aborting driver!"
	    exit 1
	fi
    done
fi

if [ "$HOSTNAME" = "node-2" ]; then
    for script in $OBSERVERNODESCRIPTS ; do
	cd $SRC
	$SRC/$script | tee - /local/logs/${script}.log 2>&1
	if [ ! $PIPESTATUS -eq 0 ]; then
	    echo "ERROR: ${script} failed; aborting driver!"
	    exit 1
	fi
    done
fi

exit 0
