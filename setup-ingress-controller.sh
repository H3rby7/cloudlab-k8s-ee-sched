#!/bin/sh

set -x

REPODIR=`dirname $0`

# Grab our libs
. "${REPODIR}/setup-lib.sh"

if [ -f $OURDIR/ingress-controller-done ]; then
    exit 0
fi

logtstart "ingress-controller"

# Add helm repo
helm repo add ingress-nginx \
    https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace nginx

# Setup nginx
# https://kubernetes.github.io/ingress-nginx/

helm install nginx \
    ingress-nginx/ingress-nginx \
    --version 4.12.0 \
    --namespace nginx \
    --wait

logtend "ingress-controller"
touch $OURDIR/ingress-controller-done
exit 0
