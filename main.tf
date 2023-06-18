terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.60.0"
    }
  }
}

provider "azurerm" {
  features {}
 # cli_exec_path =  "/usr/bin/az"
}


# Create Azure Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network_name
  address_space       = var.virtual_network_address_space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create Web Apps
resource "azurerm_app_service" "example" {
  count                = 2
  name                 = "${var.web_app_name}-${count.index}"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  app_service_plan_id  = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}

# Create Public IP
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

# Create Subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Application Gateway
resource "azurerm_application_gateway" "example" {
  name                = var.application_gateway_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  frontend_ip_configuration {
    name                  = "frontend_ip_configuration_name"
    public_ip_address_id  = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = "backend_address_pool_name"
  }

  backend_http_settings {
    name                  = "backend_http_settings_name"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
  }

  frontend_port {
    name = "frontend_port_name"
    port = 80
  }

  gateway_ip_configuration {
    name      = "gateway_ip_configuration_name"
    subnet_id = azurerm_subnet.example.id
  }

  http_listener {
    name                           = "http_listener_name"
    frontend_ip_configuration_name = "frontend_ip_configuration_name"
    frontend_port_name             = "frontend_port_name"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                  = "request_routing_rule_name"
    rule_type             = "Basic"
    http_listener_name    = "http_listener_name"
    backend_address_pool_name    = "backend_address_pool_name"
    backend_http_settings_name   = "backend_http_settings_name"
  }

  
}
