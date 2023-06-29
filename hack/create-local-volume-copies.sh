#! /bin/bash

# PVCs to ignore
ignore=()

createTempPod() {
  image=$1
  namespace=$2
  nodeName=$3
  pvcName=$4

  kubectl run "temp-$pvcName-volume-copier" -n "$namespace" --image="$image" --overrides='{
              "apiVersion": "v1",
              "spec": {
                  "containers": [
                    {
                      "image": '\""$image"\"',
                      "name": "copier",
                      "command": ["/bin/sh", "-c", "--"],
                      "args": ["while true; do sleep 30; done;"],
                      "volumeMounts": [
                        {
                          "mountPath": "/mnt",
                          "name": "mnt"
                        }
                      ]
                    }
                  ],
                  "volumes": [
                    {
                      "name": "mnt",
                      "persistentVolumeClaim": {
                        "claimName": '\""$pvcName"\"'
                      }
                    }
                  ],
                  "nodeSelector": {
                    "kubernetes.io/hostname": '\""$nodeName"\"'
                  },
                  "restartPolicy": "Never"
              },
              "status": {}
            }'
  kubectl wait -n $namespace --for=condition=Ready "pod/temp-$pvcName-volume-copier"

#   return 0
}

backupGenericVolume () {
  image='busybox'
  namespace=$1
  nodeName=$2
  pvcName=$3
  date=$(date +%F)

  # create temp pod
  createTempPod $image $namespace $nodeName $pvcName

  # create backup
  kubectl exec -it -n $namespace "temp-$pvcName-volume-copier" -- tar -zcf /tmp/backup.tar.gz /mnt

  # copy backup to local
  kubectl cp "$namespace/temp-$pvcName-volume-copier:/tmp/backup.tar.gz" "backups/auto/$namespace-$pvcName-$date.tar.gz"
  echo "Created backups/auto/$namespace-$pvcName-$date.tar.gz from $pvcName in $namespace"

  # delete temp pod
  kubectl delete pod "temp-$pvcName-volume-copier" -n "$namespace"

  echo "Delete returned $?"

  return 0
}

# backupGenericVolume
# backupMySQLVolume

while [[ $# -gt 1 ]]; do
  key="$1"
  value="$2"
  [[ $key == --ignore ]] && ignore+=("$value")
  shift 2
done

# loop over PVC
# kubectl get pvc -A -o json | jq -j '.items[] | "\(.metadata.namespace) \(.metadata.name) \(.spec.volumeName)\n"' | while read i; do
readarray -t pvcs < <(kubectl get pvc -A -o json | jq -j '.items[] | "\(.metadata.namespace) \(.metadata.name) \(.spec.volumeName)\n"')
for i in "${pvcs[@]}"; do
  arr=($i)
  namespace=${arr[0]}
  pvcName=${arr[1]}
  volumeName=${arr[2]}
  ignored=$(echo ${ignore[@]} | grep -o "$pvcName" | wc -w)
  if [ $ignored -ne 0 ]; then
    echo "Ignoring $pvcName in $namespace ($volumeName), on ignore list"
    continue
  fi

  # get node name currently attached to
  attachment=$(kubectl get volumeattachment | grep $volumeName)
  if [ -z "$attachment" ]; then
    echo "Ignoring $pvcName in $namespace ($volumeName), not attached"
    continue
  fi
  attachmentArr=($attachment)
  nodeName=${attachmentArr[3]}

  backupGenericVolume $namespace $nodeName $pvcName
#   echo "Backing up $namespace $nodeName $pvcName"
done
