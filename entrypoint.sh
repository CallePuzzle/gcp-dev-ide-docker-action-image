#!/bin/bash

echo $INPUT_SA_KEY | base64 -di > service_account.json
envsubst < inventory.gcp.tpl.yml | tee inventory.gcp.yml
ansible-playbook -i inventory.gcp.yml playbook.yaml
