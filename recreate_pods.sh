#!/bin/bash

# Update the required env vars for the first pod in each Deployment.
# This will kick off a rolling update.
# Do this so that the secrets can be remounted.

if [ -z "$DEPLOYMENTS" ]; then
    echo "WARNING: DEPLOYMENTS not provided. Secret changes may not be reflected."
    exit
fi

DEPLOYMENTS=(${DEPLOYMENTS})
DATE=$(date)
NAMESPACE=${NAMESPACE:-default}

for DEPLOYMENT in $DEPLOYMENTS
do
    NAME=$(kubectl get deployments --namespace $NAMESPACE $DEPLOYMENT -o=template --template='{{index .spec.template.spec.containers 0 "name"}}')
    PATCH=$(NAME=$NAME DATE=$DATE echo "{\"spec\": {\"template\": {\"spec\": {\"containers\": [{\"name\": \"$NAME\", \"env\": [{\"name\": \"LETSENCRYPT_CERT_REFRESH\", \"value\": \"$DATE\"}]}]}}}}")
    echo "PATCHING ${DEPLOYMENT}: ${PATCH}"
    kubectl patch deployment --namespace $NAMESPACE $DEPLOYMENT --type=strategic -p "$PATCH"
done
