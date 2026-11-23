#!/bin/bash

ssh -i "${pk}" -o "UserKnownHostsFile=\"${genDir}/known_hosts\"" ${user}@${ip} "$@"