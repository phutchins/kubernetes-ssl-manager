# kubernetes-ssl-manager

# Problem
When deploying services to Kubernetes, a certificate has to be injected into the container via secret. It doesn't make sense to have each container renew it's own certificates as it's state can be wiped at any given time.

# Solution
Build a service within each Kubernetes namespace that handles renewing all certificates used in that namespace. This service would kick off the request to renew each cert at a predetermined interval. It would then accept all verification requests ( GET request to domain/.well-known/acme-challenge ) and respond as necessary. After being issued the new certificate, it would recreate the appropriate secret which contains that certificate and initiate a restart of any container or service necessary.

Available on docker hub as [phutchins/kubernetes-ssl-manager](https://hub.docker.com/r/phutchins/kubernetes-ssl-manager)

## Useful commands

### Generate a new set of certs

Once this container is running you can generate new certificates using:

```
kubectl exec -it <pod> -- bash -c 'EMAIL=fred@fred.com DOMAINS=example.com foo.example.com ./fetch_certs.sh'
```

### Save the set of certificates as a secret

```
kubectl exec -it <pod> -- bash -c 'DOMAINS=example.com foo.example.com ./save_certs.sh'
```

### Refresh the certificates

```
kubectl exec -it <pod> -- bash -c 'EMAIL=fred@fred.com DOMAINS=example.com foo.example.com SECRET_NAME=foo DEPLOYMENTS=bar ./refresh_certs.sh'
```

## Environment variables:

 - EMAIL - the email address to obtain certificates on behalf of.
 - DOMAINS - a space separated list of domains to obtain a certificate for.
 - LETSENCRYPT_ENDPOINT
   - If set, will be used to populate the /etc/letsencrypt/cli.ini file with
     the given server value. For testing use
     https://acme-staging.api.letsencrypt.org/directory
 - DEPLOYMENTS - a space separated list of deployments whose pods should be
   refreshed after a certificate save
 - SECRET_NAME - the name to save the secrets under
 - NAMESPACE - the namespace under which the secrets should be available
 - CRON_FREQUENCY - the 5-part frequency of the cron job. Default is a random
   time in the range `0-59 0-23 1-27 * *`
