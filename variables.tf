variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "container-app-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    project = "static-website"
  }
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

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_prefixes" {
  description = "Address prefixes for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_prefixes" {
  description = "Address prefixes for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  type        = string
  default     = "container-app-gateway"
}