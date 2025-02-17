#!/bin/sh

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/kubernetes-extra-done ]; then
    exit 0
fi

logtstart "kubernetes-extra"

maybe_install_packages pssh

# Generate a cluster-wide token for an admin account, and dump it into
# the profile-setup web dir.
kubectl create serviceaccount admin -n default
kubectl create clusterrolebinding cluster-default-admin --clusterrole=cluster-admin --serviceaccount=default:admin
hassecret=`kubectl get serviceaccount admin -n default -o 'jsonpath={.secrets}'`
if [ -n "$hassecret" ]; then
    secretid=`kubectl get serviceaccount admin -n default -o 'go-template={{(index .secrets 0).name}}'`
else
    #
    # Newer kubernetes lacks automatic secrets for serviceaccounts.
    #
    kubectl -n default apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: admin-secret
  annotations:
    kubernetes.io/service-account.name: admin
type: kubernetes.io/service-account-token
EOF
    secretid="admin-secret"
fi
tries=5
while [ $tries -gt 0 ]; do
    token=`kubectl get secrets $secretid -o 'go-template={{.data.token}}' | base64 -d`
    if [ -n "$token" ]; then
	break
    else
	tries=`expr $tries - 1`
	sleep 8
    fi
done
if [ -z "$token" ]; then
    echo "ERROR: failed to get admin token, aborting!"
    exit 1
fi
echo -n "$token" > $OURDIR/admin-token.txt
chmod 644 $OURDIR/admin-token.txt

# Make kubeconfig and token available in profile-setup web dir.
cp -p ~/.kube/config $OURDIR/kubeconfig
chmod 644 $OURDIR/kubeconfig

# Make $SWAPPER a member of the docker group, so that they can do stuff sans sudo.
parallel-ssh -h $OURDIR/pssh.all-nodes sudo usermod -a -G docker $SWAPPER

# If the user wants a local, private, insecure registry on $HEAD $MGMTLAN, set that up.
if [ "$DOLOCALREGISTRY" = "1" ]; then
    ip=`getnodeip $HEAD $MGMTLAN`
    $SUDO docker create --restart=always -p $ip:5000:5000 --name local-registry registry:2
    $SUDO docker start local-registry
fi

# If the user wanted NFS, make a dynamic nfs subdir provisioner the default
# storageclass.
if [ -n "$DONFS" -a "$DONFS" = "1" ]; then
    NFSSERVERIP=`getnodeip $HEAD $DATALAN`
    helm repo add nfs-subdir-external-provisioner \
        https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
    helm repo update
    cat <<EOF >$OURDIR/nfs-provisioner-values.yaml
nfs:
  server: "$NFSSERVERIP"
  path: $NFSEXPORTDIR
  mountOptions:
    - "nfsvers=3"
storageClass:
  defaultClass: true
EOF
    helm install nfs-subdir-external-provisioner \
        nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
	-f $OURDIR/nfs-provisioner-values.yaml --wait
fi



logtend "kubernetes-extra"
touch $OURDIR/kubernetes-extra-done
exit 0
