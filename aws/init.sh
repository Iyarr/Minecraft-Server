#!/bin/bash

aws configure set default.region ap-northeast-1
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

aws ssm put-parameter \
        --name ec2-ssh-key-test \
        --value file:///root/.ssh/my_key \
        --type String \
        --overwrite

aws ssm put-parameter \
        --name ec2-ssh-key.pub-test \
        --value file:///root/.ssh/my_key.pub \
        --type String \
        --overwrite 

#terraform init

#terraform apply -auto-approve