#!/bin/bash
set -e

if [[ $# -ne 1 || ! $1 =~ ^(1[9]|2[0-9]|3[0-9])\.\ .*$ ]]; then
    echo "Please enter the exercise name as an argument and try again."
    exit 1
fi
EX=$1
echo "Creating Terraform project \"$1\""

mkdir -p "$EX/templates"

cp -R Templates/. "./$EX/"

find "./$EX" -type f -name '*.template' | while IFS= read -r file; do
    mv "$file" "${file%.template}"
done

cd "./$EX"

#touch variables.tf variables.tfvars output.tf

terraform init