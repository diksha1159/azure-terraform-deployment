variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
}

variable "resource_group_location" {
  description = "Location for the Azure Resource Group."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the Virtual Network."
  type        = string
}

variable "virtual_network_address_space" {
  description = "Address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan."
  type        = string
}

variable "web_app_name" {
  description = "Name of the Web App."
  type        = string
}

variable "application_gateway_name" {
  description = "Name of the Application Gateway."
  type        = string
}
