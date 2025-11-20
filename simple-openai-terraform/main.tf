resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

module "openai" {
  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "~> 0.7"

  name                = var.openai_service_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  kind                = "OpenAI"
  sku_name            = "S0"

  cognitive_deployments = { for d in var.openai_models : d.deployment_name => {
    name = d.deployment_name
    model = {
      format  = "OpenAI"
      name    = d.model_name
      version = d.model_version
    }
    scale = {
      type     = d.sku_name
      capacity = d.sku_capacity
    }
  } }

  public_network_access_enabled      = var.public_network_access == "Enabled"
  outbound_network_access_restricted = !var.outbound_network_access_enabled

  tags = var.tags

  depends_on = [azurerm_resource_group.this]
}
