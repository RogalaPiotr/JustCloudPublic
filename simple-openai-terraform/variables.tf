variable "resource_group_name" {
  type        = string
  description = "Name of the resource group for OpenAI deployment"

  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
  default     = "swedencentral"

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must not be empty."
  }
}

variable "openai_service_name" {
  type        = string
  description = "Name of the Azure OpenAI service (Cognitive Services account)"

  validation {
    condition     = length(var.openai_service_name) >= 2 && length(var.openai_service_name) <= 64
    error_message = "OpenAI service name must be between 2 and 64 characters."
  }
}

variable "openai_models" {
  type = list(object({
    deployment_name = string
    model_name      = string
    model_version   = string
    sku_name        = string
    sku_capacity    = number
  }))
  description = "List of OpenAI models to deploy as cognitive_deployments"

  validation {
    condition     = alltrue([for m in var.openai_models : contains(["Standard", "GlobalStandard"], m.sku_name)])
    error_message = "Each sku_name must be either 'Standard' or 'GlobalStandard'."
  }

  validation {
    condition     = alltrue([for m in var.openai_models : m.sku_capacity > 0])
    error_message = "Each sku_capacity must be greater than 0."
  }

  validation {
    condition     = length(var.openai_models) > 0
    error_message = "At least one model must be provided in openai_models."
  }
}

variable "outbound_network_access_enabled" {
  type        = bool
  description = "Enable outbound network access for the OpenAI service"
  default     = true
}

variable "public_network_access" {
  type        = string
  description = "Public network access setting (Enabled or Disabled)"
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Public network access must be either 'Enabled' or 'Disabled'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to resources"
  default     = {}
}
