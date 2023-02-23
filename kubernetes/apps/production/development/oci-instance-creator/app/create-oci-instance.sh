#!/bin/sh

echo "Initializing terraform cache"
terraform init

terraform plan -out=plan.tfplan

attempt=0

while true
do
    sleep_time=$((2 + RANDOM % 11))
    echo "Sleeping for ${sleep_time}s"
    sleep $sleep_time
    echo "Starting attempt #${attempt}"
    terraform apply -no-color -auto-approve > tf_apply.log 2>&1
    status=$?

    if [ $status -eq 0 ]; then
        success="true"
        error=""
    else
        success="false"
        error=$(cat tf_apply.log | grep "Error" | xargs)
    fi

    create_record_response=$(wget -q -O- \
        --post-data="{\"data_center\":\"${TF_VAR_region}\",\"availability_domain\":\"${TF_VAR_availability_domain}\",\"success\":\"${success}\",\"source\":\"k8s1\",\"error\":\"${error}\"}" \
        --header="Content-Type:application/json" \
        --header="Authorization: ${PB_TOKEN}" \
        "${PB_BASE}/api/collections/oci_instance_creation_attempts/records"
    )
    attempt=$((attempt+1))
done
