output "app_gateway_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.main.id
}

output "frontend_ip" {
  description = "Frontend IP address of the Application Gateway"
  value       = azurerm_public_ip.app_gateway.ip_address
}