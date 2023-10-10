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

resource "azapi_update_resource" "job" {
  type      = "Microsoft.Automation/automationAccounts/jobs@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      parameters = {
        key01 = "value01"
        key02 = "value02"
      }
      runOn = ""
      runbook = {
        name = "TestRunbook"
      }
    }
  })
}

data "azapi_resource_action" "output" {
  type        = "Microsoft.Automation/automationAccounts/jobs@2022-08-08"
  resource_id = azapi_update_resource.job.id
  action      = "output"
  method      = "GET"
}

data "azapi_resource_action" "resume" {
  type        = "Microsoft.Automation/automationAccounts/jobs@2022-08-08"
  resource_id = azapi_update_resource.job.id
  action      = "resume"
  method      = "POST"
}

data "azapi_resource_action" "runbookContent" {
  type        = "Microsoft.Automation/automationAccounts/jobs@2022-08-08"
  resource_id = azapi_update_resource.job.id
  action      = "runbookContent"
  method      = "GET"
}

data "azapi_resource_action" "stop" {
  type        = "Microsoft.Automation/automationAccounts/jobs@2022-08-08"
  resource_id = azapi_update_resource.job.id
  action      = "stop"
  method      = "POST"
}

data "azapi_resource_action" "suspend" {
  type        = "Microsoft.Automation/automationAccounts/jobs@2022-08-08"
  resource_id = azapi_update_resource.job.id
  action      = "suspend"
  method      = "POST"
}

data "azapi_resource_list" "listJobsByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/jobs@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_update_resource.job]
}

