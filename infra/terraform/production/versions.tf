# Managed by OpenTofu (not Terraform) — same HCL syntax, open-source license
terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "resource-ayo-ai"
    storage_account_name = "ayoterraformstate"
    container_name       = "tfstate"
    key                  = "production.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "badacd6b-2370-4fa4-8818-7f8ff34b0013"
}
