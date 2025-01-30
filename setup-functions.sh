#!/bin/sh

##
## Get internal service functions (uBench CustomFunctions) from github and make it available at
## /internal-svc-functions
##

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/setup-functions-done ]; then
    echo "setup-functions already ran; not running again"
    exit 0
fi

logtstart "functions"

echo "Setting up '/functions' directory with input data"

$SUDO mkdir -p /internal-svc-functions
$SUDO chmod 777 /internal-svc-functions

# TODO: Use specific REF rather than the main branch
base_url="https://github.com/H3rby7/cloudlab-k8s-ee-sched-functions/raw/refs/heads/main"

echo "Getting 'Colosseum.py' ..."
$SUDO wget -O Colosseum.py "${base_url}/Colosseum.py"
$SUDO mv Colosseum.py /internal-svc-functions/

echo "Getting 'Loader.py' ..."
$SUDO wget -O Loader.py "${base_url}/Loader.py"
$SUDO mv Loader.py /internal-svc-functions/


$SUDO ls -al /internal-svc-functions/

logtend "functions"

touch $OURDIR/setup-functions-done

exit 0
