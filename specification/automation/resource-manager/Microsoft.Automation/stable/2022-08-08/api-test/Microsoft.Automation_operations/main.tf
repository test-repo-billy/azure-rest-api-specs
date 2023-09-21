terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
  skip_provider_registration = false
}

variable "resource_name" {
  type    = string
  default = "acctest0001"
}

variable "location" {
  type    = string
  default = "westeurope"
}
data "azapi_resource_list" "listOperationsByTenant" {
  type      = "Microsoft.Automation/operations@2022-08-08"
  parent_id = "/"
}

