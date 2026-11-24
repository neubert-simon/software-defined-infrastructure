#!/bin/bash

if [ $# -lt 2 ]; then
   echo "usage: .../bin/scp ... devops@${ip} ..."
else
   scp -i "${pk}" -o "UserKnownHostsFile=\"${exDir}/gen/known_hosts\"" "$@"
fi