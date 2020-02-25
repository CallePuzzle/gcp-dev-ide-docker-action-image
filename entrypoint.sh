#!/usr/bin/env bash

set -e

source /app/venv/bin/activate
echo $INPUT_SA_KEY | base64 -di > service_account.json
envsubst < inventory.gcp.tpl.yml | tee inventory.gcp.yml
gcloud auth activate-service-account --key-file=service_account.json
ansible-playbook -i inventory.gcp.yml playbook.yaml
