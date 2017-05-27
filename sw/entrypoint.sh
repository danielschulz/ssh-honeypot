#!/bin/bash

mkdir -p ${DIRECTORY_LOGS} ${DIRECTORY_DATA}

/apps/sw/tools/ssh-honeypot/pshitt/pshitt -k /apps/sw/data/keyfiles/keyfile -l ${DIRECTORY_LOGS}/pshitt.log -o ${DIRECTORY_DATA}/data.json -t ${THREADS} -v
