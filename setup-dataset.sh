#!/bin/sh

##
## Get input dataset from github and make it available as 
## /dataset/traces.csv
##

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/setup-dataset-done ]; then
    echo "setup-dataset already ran; not running again"
    exit 0
fi

logtstart "dataset"

$SUDO mkdir -p /dataset
$SUDO chmod 777 /dataset
# TODO: when working, use specific REF rather than the main branch
$SUDO wget -O traces.csv https://github.com/H3rby7/cloudlab-k8s-ee-sched-data/raw/refs/heads/main/2774/sampled_traces.csv
$SUDO mv traces.csv /dataset/
$SUDO ls -al /dataset/

logtend "dataset"

touch $OURDIR/setup-dataset-done

exit 0
