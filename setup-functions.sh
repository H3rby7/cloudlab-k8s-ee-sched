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

base_url=`awk -F'[<>]' '$0 ~ /name="emulab.net.parameter.benchmarkFunctionsBaseURL"/ {print $3}' $OURDIR/manifests.0.xml`

echo "Getting InternalServiceFunctions from '${base_url}'"

echo "Getting 'Loader.py' ..."
$SUDO wget -O Loader.py "${base_url}/Loader.py"
if [ $? -ne 0 ]; then
    echo "FATAL -> Required download failed!"
    exit 1
fi
$SUDO mv Loader.py /internal-svc-functions/


$SUDO ls -al /internal-svc-functions/

logtend "functions"

touch $OURDIR/setup-functions-done

exit 0
