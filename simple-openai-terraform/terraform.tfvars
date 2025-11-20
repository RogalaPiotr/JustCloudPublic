resource_group_name = "rg-openai-simple-dev"
location            = "swedencentral"
openai_service_name = "oai-simple-dev"

openai_models = [
  {
    deployment_name = "gpt-4o-mini"
    model_name      = "gpt-4o-mini"
    model_version   = "2024-07-18"
    sku_name        = "Standard"
    sku_capacity    = 120
  },
  {
    deployment_name = "gpt-5-chat"
    model_name      = "gpt-5-chat"
    model_version   = "2025-10-03"
    sku_name        = "GlobalStandard"
    sku_capacity    = 50
  }
]

outbound_network_access_enabled = true
public_network_access           = "Enabled"

tags = {
  Environment = "development"
  Project     = "SimpleOpenAI"
  ManagedBy   = "Terraform"
}
