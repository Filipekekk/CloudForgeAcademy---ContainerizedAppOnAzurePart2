variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of public subnets for Application Gateway"
  type        = list(string)
}

variable "backend_pool_address" {
  description = "Backend pool address (Container App URL)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}