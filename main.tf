terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "static-website-rg"
    storage_account_name = "tfstatefilip1767789663"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
  # Remote state backend configuration would go here
  # This replaces the AWS S3 + DynamoDB pattern
}

# Data source for current subscription to get tenant information
data "azurerm_client_config" "current" {}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source                  = "./modules/networking"
  resource_group_name     = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  tags                    = var.tags
  address_space           = var.address_space
  public_subnet_prefixes  = var.public_subnet_prefixes
  private_subnet_prefixes = var.private_subnet_prefixes
}

# Logging Module
module "logging" {
  source              = "./modules/logging"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.tags
}

# Container Apps Module
module "container_app" {
  source                     = "./modules/container_app"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  tags                       = var.tags
  container_image            = var.container_image
  container_cpu              = var.container_cpu
  container_memory           = var.container_memory
  private_subnet_ids         = module.networking.private_subnet_ids
  log_analytics_workspace_id = module.logging.workspace_id
}

# Application Gateway Module
module "app_gateway" {
  source               = "./modules/app"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  tags                 = var.tags
  app_gateway_name     = var.app_gateway_name
  public_subnet_ids    = module.networking.public_subnet_ids
  backend_pool_address = module.container_app.container_app_url
}

# Add diagnostic settings after all resources are created
resource "azurerm_monitor_diagnostic_setting" "app_gateway_diagnostic" {
  name                       = "app-gateway-diagnostics"
  target_resource_id         = module.app_gateway.app_gateway_id
  log_analytics_workspace_id = module.logging.workspace_id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "container_app_diagnostic" {
  name                       = "container-app-diagnostics"
  target_resource_id         = module.container_app.container_app_id
  log_analytics_workspace_id = module.logging.workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}