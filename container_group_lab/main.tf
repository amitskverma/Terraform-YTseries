terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}


# --- Resource Group Data ---
data "azurerm_resource_group" "main" {
  name = "1-691fa41a-playground-sandbox" #Replace with your actual resource group name
}


# --- Container Group ---
resource "azurerm_container_group" "main" {
  name                = "demo-cg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "demo-cg-8623342" #Must be globally unique
  os_type             = "Linux"
  
  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
# --- Output ---
output "dns_hostname" {
  value = azurerm_container_group.main.fqdn
}
