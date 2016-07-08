#!/bin/bash

# Get all certs that we manage and their expiration dates
CERT_SECRET_NAMES=$(kubectl get secrets --namespace=storj-prod -o jsonpath='{.items[?(@.metadata.type=="cert")].metadata.name}')

# Trim off the prepending 'cert.' from each of the cert names

# Get a list of secrets that contain certs

# Remove certs from the list that we already have secrets for

# If we still have some certs left, renew them all
# should not cost us any extra hits on the rate limiter if this is done in one request

