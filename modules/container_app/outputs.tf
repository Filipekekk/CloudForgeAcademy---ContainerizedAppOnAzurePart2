output "container_app_id" {
  description = "ID of the Container App"
  value       = azurerm_container_app.main.id
}

output "container_app_url" {
  description = "URL of the Container App"
  value       = azurerm_container_app.main.latest_revision_fqdn
}

output "environment_id" {
  description = "ID of the Container App Environment"
  value       = azurerm_container_app_environment.main.id
}