#!/bin/bash

ssh -i "${pk}" -o "UserKnownHostsFile=\"${exDir}/gen/known_hosts\"" ${user}@${ip} "$@"