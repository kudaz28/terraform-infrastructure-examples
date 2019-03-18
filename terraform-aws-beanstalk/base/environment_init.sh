#!/bin/bash

# Usage: ./init.sh once to initialize remote storage for this environment.
# Subsequent tf actions in this environment don't require re-initialization,
# unless you have completely cleared your .terraform cache.
#
# terraform plan  -var-file=./production.tfvars
# terraform apply -var-file=./production.tfvars

if [ $# -ne 3 ]; then
    echo 'usage: init.sh suffix application_name environment
    e.g. init.sh cust-search api-jva-cust-search devh'
    exit 1
fi

suffix=$1
application_name=$2
environment=$3

sed -i "s/APPLICATION_NAME/${application_name}/g" ../../../base/environment.tf
sed -i "s/SUFFIX/${suffix}/g" ../../../base/environment.tf
sed -i "s/APPLICATION_NAME/${application_name}/g" backend.tf
sed -i "s/APPLICATION_NAME/${application_name}/g" ../../../base/data.tf
sed -i "s/APPLICATION_NAME/${application_name}/g" ${environment}.tfvars
sed -i "s/ENVIRONMENT/${environment}/g" backend.tf
sed -i "s/ENVIRONMENT/${environment}/g" ../../../base/data.tf
sed -i "s/ENVIRONMENT/${environment}/g" ${environment}.tfvars

terraform init
