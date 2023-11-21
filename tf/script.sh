#!/bin/bash

function clean() {
    terraform destroy -auto-approve

    rm -f -r .terraform
    rm -f .terraform.lock.hcl
    rm -f terraform.tfstate
    rm -f terraform.tfstate.backup
    rm -f $SSH_KEY_PATH/known_hosts
    rm -f $SSH_KEY_PATH/known_hosts.old
}

function start() {
    terraform init
    terraform apply -auto-approve

    cd /home/ansible
    base_url=$(echo "https:\/\/minecraft.azureedge.net\/bin-linux")
    sed -i "10s/.*/server_url=$base_url\/bedrock-server-$SERVER_VERSION.zip/" \
        /home/ansible/hosts
    sed -i "/server-name=*/s/.*/server-name=$SERVER_NAME/" /home/ansible/hosts
    sleep 90
    export ANSIBLE_HOST_KEY_CHECKING=false
    ansible-playbook -i hosts playbook.yaml
}

function restart() {
    clean
    start
}

cd /home/tf

export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_ssh_key_path=$SSH_KEY_PATH
export TF_VAR_aws_region=$region

if [ "$1" == "clean" ]; then
    clean
elif [ "$1" == "start" ]; then
    start
elif [ "$1" == "restart" ]; then
    restart
fi