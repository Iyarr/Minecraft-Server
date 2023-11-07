#!/bin/bash

ssh-keygen -t rsa -N "" -f "$SSH_KEY_PATH/id_rsa"

sed -i "3s/.*/ansible_host=$private_ip/" /home/ansible/hosts

# テキスト内のすべての / を \/ にエスケープする
# (置換前と後の文字列の/と\でもそれぞれ\をつけてエスケープされている)
# sed 's/ \/ / \\\/ /g'
# 2つのバックスラッシュ \\ は、正規表現内のバックスラッシュ自体をエスケープする
escaped_ssh_key_path=$(echo "$SSH_KEY_PATH" | sed 's/\//\\\//g')
sed -i "8s/.*/ansible_ssh_private_key_file=${escaped_ssh_key_path}\/id_rsa/" /home/ansible/hosts

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region "$region"

export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_ssh_key_path=$SSH_KEY_PATH
export TF_VAR_aws_region=$region
export TF_VAR_private_ip=$private_ip

terraform init

terraform plan -out=myplan

#terraform apply -auto-approve

#ansible-play -i hosts /home/ansible/playbook.yml

tail -f /dev/null