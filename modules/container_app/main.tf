# Create Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                = "container-app-environment"
  location            = var.location
  resource_group_name = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  infrastructure_subnet_id = var.private_subnet_ids[0]  # Use first private subnet
  internal_load_balancer_enabled = false

  tags = var.tags
}

# Create Container App
resource "azurerm_container_app" "main" {
  name                         = "container-app"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "app-container"
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name  = "PORT"
        value = "8080"
      }
    }

    ingress {
      external_enabled = false  # Only accessible within VNet
      target_port      = 8080
      traffic_weight {
        percentage = 100
        latest_revision = true
      }
    }
  }

  # Restart policy
  lifecycle {
    ignore_changes = [
      template[0].revision_suffix
    ]
  }

  tags = var.tags
}