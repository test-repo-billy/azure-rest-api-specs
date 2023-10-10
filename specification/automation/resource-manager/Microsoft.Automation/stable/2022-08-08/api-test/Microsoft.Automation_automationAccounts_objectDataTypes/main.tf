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
resource "azapi_resource" "resourceGroup" {
  type     = "Microsoft.Resources/resourceGroups@2020-06-01"
  name     = var.resource_name
  location = var.location
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    properties = {
      encryption = {
        keySource = "Microsoft.Automation"
      }
      publicNetworkAccess = true
      sku = {
        name = "Basic"
      }
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

data "azapi_resource_id" "objectDataType" {
  type      = "Microsoft.Automation/automationAccounts/objectDataTypes@2023-12-12"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
}

data "azapi_resource_action" "fields" {
  type        = "Microsoft.Automation/automationAccounts/objectDataTypes@2022-08-08"
  resource_id = data.azapi_resource_id.objectDataType.id
  action      = "fields"
  method      = "GET"
}

