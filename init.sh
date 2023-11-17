#!/bin/bash

ssh-keygen -t rsa -N "" -m PEM -f "$SSH_KEY_PATH/ec2_keypair.pem"

# テキスト内のすべての / を \/ にエスケープする
# (置換前と後の文字列の/と\でもそれぞれ\をつけてエスケープされている)
# sed 's/ \/ / \\\/ /g'
# 2つのバックスラッシュ \\ は、正規表現内のバックスラッシュ自体をエスケープする
escaped_ssh_key_path=$(echo "$SSH_KEY_PATH" | sed 's/\//\\\//g')
sed -i "8s/.*/ansible_ssh_private_key_file=${escaped_ssh_key_path}\/ec2_keypair.pem/" /home/ansible/hosts

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region "$region"

/home/tf/script.sh start

#ansible-play -i hosts /home/ansible/playbook.yml

tail -f /dev/null