#!/bin/bash
set -e

# Check to see if letsencrypt is running and do nothing if it is
GREP=$(ps aux | grep refresh_certs | grep -v "grep")
RESPONSE=$?
if [[ $RESPONSE != 0 ]]
then
    echo "Refresh script is already running. Exiting!"
    exit 1
fi

echo "$(date) Fetching certs..."
/letsencrypt/fetch_certs.sh

echo "$(date) Saving certs..."
/letsencrypt/save_certs.sh

echo "$(date) Recreating pods..."
/letsencrypt/recreate_pods.sh
