KIND=$1
NAME=$2
RELEASE_NAME=$3
NAMESPACE=$4

kubectl -n $NAMESPACE annotate $KIND $NAME meta.helm.sh/release-name=$RELEASE_NAME
kubectl -n $NAMESPACE annotate $KIND $NAME meta.helm.sh/release-namespace=$NAMESPACE
kubectl -n $NAMESPACE label $KIND $NAME app.kubernetes.io/managed-by=Helm
