#!/usr/bin/env bash

set -e

INSTANCE_NAME=$(echo "$GITHUB_REPOSITORY-$INPUT_GITHUB_ACTOR_EMAIL" | perl -ne 'print lc' | perl -pe 's/.*\/(.*)/$1/s' | perl -pe 's/((?![a-z0-9]).)/-/gm')
export INSTANCE_NAME

source /app/venv/bin/activate
echo $INPUT_SA_KEY | base64 -di > service_account.json
envsubst < /app/inventory.gcp.tpl.yml | tee inventory.gcp.yml

gcloud auth activate-service-account --key-file=service_account.json

cp /app/ansible.cfg ansible.cfg
ansible-playbook -i inventory.gcp.yml /app/playbook.yaml
#ansible-playbook -i inventory.gcp.yml /app/delete-instance.yml