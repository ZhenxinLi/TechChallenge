#!/bin/sh


echo "[web]" >> inventory.yml
echo "$(cd .. && cat .env | grep -oP "(?<=(WEB\=)).*")" >> inventory.yml

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -v -i inventory.yml -e 'record_host_keys=True' -u ec2-user --extra-vars "db_endpoint=$(cd ../../infra && terraform output db_endpoint) db_user=$(cd ../../infra && terraform output db_user) db_pass=$(cd ../../infra && terraform output db_password) lb_endpoint=$(cd ../../infra && terraform output lb_endpoint)" ../playbook.yml

