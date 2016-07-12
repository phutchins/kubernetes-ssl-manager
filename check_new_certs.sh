#!/bin/bash

# Get all certs that we manage and their expiration dates

# Need to make sure the escaped single quotes work here instead of double quotes, have to parse env var for secret prefix
#SECRET_PREFIX="cert"

CERT_SECRET_NAMES=$(kubectl get secrets --namespace=storj-prod -o jsonpath=\'{.items[?(@.metadata.labels.type=="$SECRET_PREFIX")].metadata.name}\')

# Trim off the prepending 'cert.' from each of the cert names

# Get a list of secrets that contain certs

# Remove certs from the list that we already have secrets for

# If we still have some certs left, renew them all
# should not cost us any extra hits on the rate limiter if this is done in one request

