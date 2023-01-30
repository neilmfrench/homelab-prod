#!/bin/bash
echo "Starting OCI creator attempt"
n=0
terraform apply -auto-approve > tf_apply.log
status=$?
until [ $status -eq 0 ]
do
  echo "Failed to create resources on attempt $n, destroying and trying again"
  n=$((n+1))
  terraform destroy -auto-approve > tf_destroy.log
  destroy_status=$?
  if [ $destroy_status -ne 0 ]; then
    echo "Failed to destroy!! Retrying..."
    terraform destroy -auto-approve > tf_destroy.log
    destroy_status=$?
    if [ $destroy_status -ne 0 ]; then
      echo "Failed to destroy again! Exiting"
      break
    fi
  fi
  echo "Destroyed resources, re-applying"
  sleep 30
  terraform apply -auto-approve > tf_apply.log
  status=$?
  sleep 30
done
echo "Resources created on attempt $n (!!!!)"
