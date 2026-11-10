#!/bin/bash
set -e

if [[ $# -ne 1 || ! $1 =~ ^(1[9]|2[0-9]|3[0-9])\.\ .*$ ]]; then
    echo "Please enter the exercise name as an argument and try again."
    exit 1
fi
EX=$1
echo "Creating Terraform project \"$1\""

mkdir -p "$EX/templates"

cp "Templates/.env.template" "./$EX/.env"
cp "Templates/setup.tf.template" "./$EX/setup.tf"
cp "Templates/main.tf.template" "./$EX/main.tf"

cd "./$EX"
touch variables.tf
touch variables.tfvars
touch output.tf

terraform init