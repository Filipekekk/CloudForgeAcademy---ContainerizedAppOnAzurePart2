variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "container_image" {
  description = "Container image to deploy"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_cpu" {
  description = "CPU units for the container"
  type        = number
  default     = 0.25
}

variable "container_memory" {
  description = "Memory in GB for the container"
  type        = string
  default     = "0.5Gi"
}

variable "private_subnet_ids" {
  description = "IDs of private subnets for Container App Environment"
  type        = list(string)
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  type        = string
}