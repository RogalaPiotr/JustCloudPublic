# Azure OpenAI Terraform Deployment

Simple Terraform example for deploying Azure OpenAI service using Azure Verified Module (AVM).

**Blog post:** <https://blog.justcloud.pl>

## What's included

- Resource Group
- Azure OpenAI Service (Cognitive Services)
- Multiple model deployments support

## Usage

```bash
# Authenticate
az login

# Deploy
terraform init
terraform plan
terraform apply

# Get endpoint and keys
terraform output
```

## Configuration

Edit `terraform.tfvars`:

```hcl
openai_models = [
  {
    deployment_name = "gpt-4o-mini"
    model_name      = "gpt-4o-mini"
    model_version   = "2024-07-18"
    sku_name        = "Standard"
    sku_capacity    = 120
  }
]
```

## Requirements

- Terraform >= 1.6
- Azure CLI
- Azure subscription with OpenAI quota

## Module

Uses [Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-cognitiveservices-account/azurerm) for Cognitive Services.
