#!/bin/bash

# Usage: ./init.sh once to initialize remote storage for this environment.
# Subsequent tf actions in this environment don't require re-initialization,
# unless you have completely cleared your .terraform cache.
#
# terraform plan  -var-file=./production.tfvars
# terraform apply -var-file=./production.tfvars
if [ $# -ne 2 ]; then
    echo 'usage: init.sh application_name environment
    e.g. init.sh api-jva-cust-search stsa'
    exit 1
fi

application_name=$1
environment=$2

sed -i "s/APPLICATION_NAME/${application_name}/g" backend.tf
sed -i "s/ENVIRONMENT/${environment}/g" backend.tf
sed -i "s/APPLICATION_NAME/${application_name}/g" ../../../base/application.tf

terraform init
