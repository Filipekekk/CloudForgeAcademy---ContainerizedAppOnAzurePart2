resource_group_name = "static-website"
location            = "polandcentral"
container_image     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
container_cpu       = 0.25
container_memory    = "0.5Gi"
app_gateway_name    = "container-app-gateway"

tags = {
  project     = "static-website"
  environment = "dev"
  owner       = "team"
}