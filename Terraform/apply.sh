#!/bin/bash
set -e
EX=$1

if ! [[ $EX =~ ^[0-9]+$ && $EX -ge 19 && $EX -le 38 ]]; then
  echo "Please provide the exercise number as a positional parameter to this script."
  exit 1
fi

cd "$(dirname "$0")"
cd "${EX}. "* || exit 1

set -a
source ./.env
set +a

terraform init
terraform apply -auto-approve

echo "Don't forget to call terraform destroy!"