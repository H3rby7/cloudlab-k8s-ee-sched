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

# Create secret for ingress BASIC AUTH
# Output file name must be 'auth' as this will be the KEY inside the secret
echo "$ADMIN_PASS" | htpasswd -n -i "$ADMIN" | tee -a auth
kubectl --namespace monitoring create secret generic ingress-basic-auth --from-file=auth
rm auth

# Setup nginx
# https://kubernetes.github.io/ingress-nginx/

helm install nginx ingress-nginx/ingress-nginx --namespace nginx --wait

logtend "ingress-controller"
touch $OURDIR/ingress-controller-done
exit 0
