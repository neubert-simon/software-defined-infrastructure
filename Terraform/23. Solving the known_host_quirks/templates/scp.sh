#!/usr/bin/env bash

if [ $# -lt 2 ]; then
   echo "usage: .../bin/scp ... devops@${ip} ..."
else
   scp -i "${pk}" -o "UserKnownHostsFile=\"${genDir}/known_hosts\"" "$@"
fi