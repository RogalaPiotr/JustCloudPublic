output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.this.id
}

output "openai_service_name" {
  description = "Name of the Azure OpenAI service"
  value       = module.openai.name
}

output "openai_service_id" {
  description = "ID of the Azure OpenAI service"
  value       = module.openai.resource_id
}

output "openai_endpoint" {
  description = "Endpoint URL for the Azure OpenAI service"
  value       = module.openai.endpoint
}

output "openai_primary_key" {
  description = "Primary access key for the Azure OpenAI service"
  value       = module.openai.primary_access_key
  sensitive   = true
}

output "openai_secondary_key" {
  description = "Secondary access key for the Azure OpenAI service"
  value       = module.openai.secondary_access_key
  sensitive   = true
}

output "deployment_names" {
  description = "List of deployed model names"
  value       = [for m in var.openai_models : m.deployment_name]
}

output "model_names" {
  description = "List of OpenAI model names"
  value       = [for m in var.openai_models : m.model_name]
}

output "model_versions" {
  description = "List of OpenAI model versions"
  value       = [for m in var.openai_models : m.model_version]
}
