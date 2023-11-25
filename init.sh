#!/bin/bash

ssh-keygen -t rsa -N "" -m PEM -f "$SSH_KEY_PATH/ec2_keypair.pem"

# テキスト内のすべての /や\ を/ を前においてエスケープする
escaped_ssh_key_path=$(echo "$SSH_KEY_PATH/ec2_keypair.pem" | sed 's/\//\\\//g')
sed -i "s/\\(ansible_ssh_private_key_file\\)=.*/\\1=${escaped_ssh_key_path}/" /home/ansible/hosts

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region "$region"

#/home/tf/script.sh start

tail -f /dev/null