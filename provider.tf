terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}


 subscription_id   = "7709ff84-1424-4b46-b645-0d25b47c1c2c"
  tenant_id         = "108bc864-cdf5-4ec3-8b7c-4eb06be1b41d"
}
