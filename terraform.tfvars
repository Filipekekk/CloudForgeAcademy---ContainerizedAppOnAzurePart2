resource_group_name = "container-app-rg"
location           = "East US"
container_image    = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
container_cpu      = 0.25
container_memory   = "0.5Gi"
app_gateway_name   = "container-app-gateway"

tags = {
  project = "static-website"
  environment = "dev"
  owner     = "team"
}