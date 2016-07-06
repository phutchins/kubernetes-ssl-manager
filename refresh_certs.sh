#!/bin/bash
set -e

if [ -e "/tmp/.letsencrypt-lock" ]
then
    echo "Nope, not gonna touch that."
    exit 1
fi

touch /tmp/.letsencrypt-lock

echo "$(date) Fetching certs..."
/letsencrypt/fetch_certs.sh

echo "$(date) Saving certs..."
/letsencrypt/save_certs.sh

echo "$(date) Recreating pods..."
/letsencrypt/recreate_pods.sh

rm /tmp/.letsencrypt-lock
