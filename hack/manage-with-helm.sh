KIND=$1
NAME=$2
RELEASE_NAME=$3
NAMESPACE=$4

kubectl annotate $KIND $NAME meta.helm.sh/release-name=$RELEASE_NAME
kubectl annotate $KIND $NAME meta.helm.sh/release-namespace=$NAMESPACE
kubectl label $KIND $NAME app.kubernetes.io/managed-by=Helm
