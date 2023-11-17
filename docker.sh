#!/bin/bash

function start() {
    terraform destroy -auto-approve

    rm -r .terraform
    rm .terraform.lock.hcl
    rm terraform.tfstate
    rm terraform.tfstate.backup
    rm $SSH_KEY_PATH/known_hosts
    rm $SSH_KEY_PATH/known_hosts.old
}

function start() {
    docker-compose up -d --build
    sleep 60
    docker-compose logs
}

function restart() {
    docker-compose rm --stop -f
    start
}


if [ "$1" == "" ]; then
    start
elif [ "$1" == "restart" ]; then
    restart
fi