#!/bin/sh

##
## Get input dataset from github and make it available at
## /dataset
##

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/setup-dataset-done ]; then
    echo "setup-dataset already ran; not running again"
    exit 0
fi

logtstart "dataset"

echo "Setting up '/dataset' directory with input data"

$SUDO mkdir -p /dataset
$SUDO chmod 777 /dataset

base_url=`awk -F'[<>]' '$0 ~ /name="emulab.net.parameter.benchmarkDatasetBaseURL"/ {print $3}' $OURDIR/manifests.0.xml`

echo "Getting dataset from '${base_url}'"

echo "Getting traces..."
$SUDO wget -O traces.csv "${base_url}/sampled_traces.tsv"
if [ $? -ne 0 ]; then
    echo "FATAL -> Required download failed!"
    exit 1
fi
$SUDO mv traces.csv /dataset/

echo "Getting deployment_ts..."
$SUDO wget -O deployment_ts.csv "${base_url}/deployment_ts.tsv"
if [ $? -ne 0 ]; then
    echo "FATAL -> Required download failed!"
    exit 1
fi
$SUDO mv deployment_ts.csv /dataset/

echo "Getting min_max_normalized_service_metrics..."
$SUDO wget -O min_max_normalized_service_metrics.csv "${base_url}/min_max_normalized_service_metrics.tsv"
if [ $? -ne 0 ]; then
    echo "FATAL -> Required download failed!"
    exit 1
fi
$SUDO mv min_max_normalized_service_metrics.csv /dataset/

echo "Getting service_graphs..."
$SUDO wget -O service_graphs.json "${base_url}/service_graphs.json"
if [ $? -ne 0 ]; then
    echo "FATAL -> Required download failed!"
    exit 1
fi
$SUDO mv service_graphs.json /dataset/

echo "Getting target_resource_means..."
$SUDO wget -O target_resource_means.json "${base_url}/target_resource_means.json"
if [ $? -ne 0 ]; then
    echo "FATAL -> Required download failed!"
    exit 1
fi
$SUDO mv target_resource_means.json /dataset/

$SUDO ls -al /dataset/

echo "Setting up '/result' directory"

$SUDO mkdir -p /result
$SUDO chmod 777 /result

$SUDO ls -al /result/

logtend "dataset"

touch $OURDIR/setup-dataset-done

exit 0
