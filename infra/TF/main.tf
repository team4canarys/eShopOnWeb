# Set the Azure Provider source and version being used
terraform {
  required_version = ">= 0.14"
  backend "remote" {
    organization = "Canarysteam4"
    workspaces {
      name = "team4workspace"
    }
    hostname     = "app.terraform.io"
    token        = "s2iFqjxDrM4ZAw.atlasv1.Jtb0Da5kYEif4V9q3BLNK088oEBIIuHBDYKBNBljCf26z3GqV2CSFVPUKpW2EWBXa0Q"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id ="b6f408e9-b240-412d-b83d-1ec4fc938ee8"
  client_id       = "c7f59d11-4e5e-4c7b-b25d-9093238144bc"
  client_secret   = "e1Z8Q~KX~KcwRolI8vdiumoVJ8U4YNfqYo-XRbUi"
  tenant_id       ="0c88fa98-b222-4fd8-9414-559fa424ce64"
 
}

resource "azurerm_resource_group" "devopsathon" {
  name     = "team4-dotnet"
  location = "eastus"
}
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "team4-sqlserver"
  resource_group_name          = azurerm_resource_group.devopsathon.name
  location                     = azurerm_resource_group.devopsathon.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Canarys@123"
}

