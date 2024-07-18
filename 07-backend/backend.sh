#!/bin/bash
component=$1
environmemt=$2
dnf install ansible -y
pip3.9 install botocore boto3
ansible-pull -i localhost, -U https://github.com/LingannaJ/expense-ansible-roles-tf.git main.yaml -e component=$component -e env=$environmemt