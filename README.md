# Langflow Deployment on Microsoft Azure

This is a deployment of Langflow on Microsoft Azure.

## Prerequisites

### Install terraform

```bash
brew install terraform
```

### Install azure cli

```bash
brew install azure-cli
```

### Login to azure

```bash
az login
```

### Set the subscription

```bash
az account set --subscription "your_subscription_id"
```

## Deploy the infrastructure

```bash
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

### Get the kube config

```bash
az aks get-credentials --resource-group langflow-dev-rg --name langflow-dev
```

### Get the cluster fqdn

```bash
az aks show --resource-group langflow-dev-rg --name langflow-dev --query fqdn --output tsv
```