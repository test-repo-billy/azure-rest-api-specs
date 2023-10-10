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

resource "azapi_resource" "connection" {
  type      = "Microsoft.Automation/automationAccounts/connections@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      connectionType = {
        name = "Azure"
      }
      description = "my description goes here"
      fieldDefinitionValues = {
        AutomationCertificateName = "mysCertificateName"
        SubscriptionID            = "subid"
      }
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_connection" {
  type        = "Microsoft.Automation/automationAccounts/connections@2022-08-08"
  resource_id = azapi_resource.connection.id
  action      = ""
  method      = "PATCH"
  body = jsonencode({
    properties = {
      description = "my description goes here"
      fieldDefinitionValues = {
        AutomationCertificateName = "myCertificateName"
        SubscriptionID            = "b5e4748c-f69a-467c-8749-e2f9c8cd3009"
      }
    }
  })
}

data "azapi_resource_list" "listConnectionsByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/connections@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.connection]
}

