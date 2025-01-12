# Create a powerful Tokenizer API using distroless

By using distroless, you ensure a low weight for your container. This full example will get you everything you need to run an API in a container that you can then use to deploy to a cloud provider like Azure.

This repository gives you a good starting point with a Dockerfile, GitHub Actions workflow, and Rust code.

## Generate a PAT

The access token will need to be added as an Action secret. [Create one](https://github.com/settings/tokens/new?description=Azure+Rust+Container+Apps+access&scopes=write:packages) with enough permissions to write to packages.

Copy the generated token and add it as a [Github repository secret](/../../settings/secrets/actions/new) with the name `PAT`. (_If that link doesn't work, make sure you're reading this on your own copy of the repo, not the original template._)


## Create an Azure Service Principal

You'll need the following:

1. An Azure subscription ID [find it here](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade) or [follow this guide](https://docs.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id)
1. A Service Principal with the following details the AppID, password, and tenant information. Create one with: `az ad sp create-for-rbac -n "REST API Service Principal"` and assign the IAM role for the subscription. Alternatively set the proper role access using the following command (use a real subscription id and replace it):

```
az ad sp create-for-rbac --name "CICD" --role contributor --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID --sdk-auth
``` 

Capture the output and add it as a [Github repository secret](/../../settings/secrets/actions/new) with the name `AZURE_CREDENTIALS`. (_If that link doesn't work, make sure you're reading this on your own copy of the repo, not the original template._)


## Azure Container Apps

Make sure you have one instance already created, and then capture the name and resource group. These will be used in the workflow file.

## No need to change defaults 

Unlike other language runtimes like Python, you don't need to change the default container service. Rust will be more than happy to use a single CPU!

## Gotchas

There are a few things that might get you into a failed state when deploying:

* Not using authentication for accessing the remote registry (ghcr.io in this case). Authentication is always required
* Not using a PAT (Personal Access Token) or using a PAT that doesn't have write permissions for "packages".
* Different port than 80 in the container. By default Azure Container Apps use 80. Update to match the container.

If running into trouble, check logs in the portal or use the following with the Azure CLI:

```
az containerapp logs  show  --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP_NAME --follow
```

Update both variables to match your environment

**NOTE** Settings for Packages in your repo may need updating. Go to [Action Settings](/../../settings/actions) and scroll down to _"Workflow Permissions"_ and make sure it shows _"Read and write permissions"_ as selected, otherwise you'll see a `403 Forbidden`
