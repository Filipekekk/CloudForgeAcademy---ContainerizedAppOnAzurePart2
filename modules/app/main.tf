# Create Public IP for Application Gateway
resource "azurerm_public_ip" "app_gateway" {
  name                = "${var.app_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create Application Gateway
resource "azurerm_application_gateway" "main" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }
  
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.public_subnet_ids[0]  # Use first public subnet
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "public_ip"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name         = "backend_pool"
    fqdns        = [var.backend_pool_address]
  }

  backend_http_settings {
    name                  = "backend_http_settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    probe_name            = "health-probe"
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "public_ip"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backend_pool"
    backend_http_settings_name = "backend_http_settings"
    priority                   = 10
  }

  probe {
    name                = "health-probe"
    protocol            = "Https"
    path                = "/"
    interval            = 30
    timeout             = 120
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
  }

  tags = var.tags
}