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
  default = "acctest0006"
}

variable "location" {
  type    = string
  default = "westus2"
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

resource "azapi_resource" "variable" {
  type      = "Microsoft.Automation/automationAccounts/variables@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      description = "my description"
      isEncrypted = false
      value       = "\"ComputerName.domain.com\""
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_variable" {
  type        = "Microsoft.Automation/automationAccounts/variables@2022-08-08"
  resource_id = azapi_resource.variable.id
  action      = ""
  method      = "PATCH"
  body = jsonencode({
    properties = {
      value = "\"ComputerName3.domain.com\""
    }
  })
}

data "azapi_resource_list" "listVariablesByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/variables@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.variable]
}

