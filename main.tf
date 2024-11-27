# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "rgname" {
  description = "Senac DevOps Class Resource Group"
  default = "SenacTFResourceGroup"
  type = string
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = "EastUS2"
}

resource "azurerm_container_app_environment" "senac" {
  name                       = "Senac-Environment"
  location                   = "EastUS2"
  resource_group_name        = azurerm_resource_group.rg.name
}

resource "azurerm_storage_account" "senacsa" {
  name                     = "senaclabsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "EastUS2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "senaclabspthalita" {
  name                = "azure-functions-senaclab-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "EastUS2"
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "senaclabazurefunctionthalita"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "EastUS2"

  storage_account_name       = azurerm_storage_account.senacsa.name
  storage_account_access_key = azurerm_storage_account.senacsa.primary_access_key
  service_plan_id            = azurerm_service_plan.senaclabsp.id

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }

  site_config {
  }
}