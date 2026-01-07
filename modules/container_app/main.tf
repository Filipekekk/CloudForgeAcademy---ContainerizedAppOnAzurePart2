# Create Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                = "container-app-env"
  location            = var.location
  resource_group_name = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  infrastructure_subnet_id = var.private_subnet_ids[0]  # Use first private subnet
  internal_load_balancer_enabled = false

  zone_redundancy_enabled = false 
  
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
  tags = var.tags
}

# Create Container App
resource "azurerm_container_app" "main" {
  name                         = "container-app"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  ingress {
      external_enabled = true  # Only accessible within VNet
      target_port      = 80
      traffic_weight {
        percentage = 100
        latest_revision = true
      }
  }

  template {
    container {
      name   = "app-container"
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name  = "PORT"
        value = "80"
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