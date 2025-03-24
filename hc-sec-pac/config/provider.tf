terraform {
  required_version = ">= 1.0.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.56.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ml4-hc"
    workspaces {
      name = "hc-sec-pac-dev"
    }
  }
}

provider "azurerm" {
  features {}
}