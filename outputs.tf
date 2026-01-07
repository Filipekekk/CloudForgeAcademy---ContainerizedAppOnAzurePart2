output "gateway_frontend_ip" {
  description = "Public IP of the Application Gateway"
  value       = module.app_gateway.frontend_ip
}

output "application_url" {
  value = "http://${module.app_gateway.frontend_ip}"
}