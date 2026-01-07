# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Create public subnets
resource "azurerm_subnet" "public" {
  count                = length(var.public_subnet_prefixes)
  name                 = "public-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_prefixes[count.index]]
}

# Create private subnets
resource "azurerm_subnet" "private" {
  count                = length(var.private_subnet_prefixes)
  name                 = "private-subnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_prefixes[count.index]]

  # Delegate to Container Apps
  delegation {
    name = "container-apps"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Create public IP for NAT Gateway
resource "azurerm_public_ip" "nat_gateway" {
  name                = "nat-gateway-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create NAT Gateway
resource "azurerm_nat_gateway" "main" {
  name                    = "container-app-nat-gateway"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

# Associate NAT Gateway with public IP
resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}

# Associate NAT Gateway with private subnets
resource "azurerm_subnet_nat_gateway_association" "private" {
  count          = length(var.private_subnet_prefixes)
  subnet_id      = azurerm_subnet.private[count.index].id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Create route table for public subnets
resource "azurerm_route_table" "public" {
  name                          = "public-route-table"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tags                          = var.tags

  route {
    name           = "Public-Route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

# Associate route table with public subnets
resource "azurerm_subnet_route_table_association" "public" {
  count          = length(var.public_subnet_prefixes)
  subnet_id      = azurerm_subnet.public[count.index].id
  route_table_id = azurerm_route_table.public.id
}