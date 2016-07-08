#!/bin/bash

# $DOMAINS should contain all domains that this container is responsible for
# renewing. The first one dictates where the cert will live.

# Inside /etc/letsencrypt/live/<domain> we have:
#
# cert.pem  chain.pem  fullchain.pem  privkey.pem
#
# We want to convert fullchain.pem into proxycert
# and privkey.pem into proxykey and then save as a secret!

if [ -z "$SECRET_PREFIX" ]; then
  SECRET_PREFIX=cert
fi


CERT_LOCATION='/etc/letsencrypt/live'

for DOMAIN in $DOMAINS; do
  SECRET_NAME="$SECRET_PREFIX.$DOMAIN"

  CERT=$(cat $CERT_LOCATION/$DOMAIN/fullchain.pem | base64 --wrap=0)
  KEY=$(cat $CERT_LOCATION/$DOMAIN/privkey.pem | base64 --wrap=0)
  DHPARAM=$(openssl dhparam 2048 | base64 --wrap=0)

  NAMESPACE=${NAMESPACE:-default}

  EXPIRE_DATE=$(openssl x509 -enddate -noout -in $CERT_LOCATION/$DOMAIN/fullchain.pem | awk -F "=" '{print $2}')

  kubectl get secrets --namespace $NAMESPACE $SECRET_NAME && ACTION=replace || ACTION=create;

  cat << EOF | kubectl $ACTION -f -
  {
   "apiVersion": "v1",
   "kind": "Secret",
   "metadata": {
     "type": "cert",
     "name": "$SECRET_NAME",
     "namespace": "$NAMESPACE"
   },
   "data": {
     "tls.crt": "$CERT",
     "tls.key": "$KEY",
     "tls.dhparam": "$DHPARAM",
     "tls.expires": "$EXPIRE_DATE"
   }
  }
EOF

done
