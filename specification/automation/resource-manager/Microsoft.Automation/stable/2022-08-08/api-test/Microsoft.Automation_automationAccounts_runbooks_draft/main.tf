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

resource "azapi_resource" "runbook" {
  type      = "Microsoft.Automation/automationAccounts/runbooks@2019-06-01"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    properties = {
      description = "This is a test runbook for terraform acceptance test"
      draft = {
      }
      logActivityTrace = 0
      logProgress      = true
      logVerbose       = true
      runbookType      = "PowerShell"
    }
  })
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

resource "azapi_update_resource" "draft" {
  type      = "Microsoft.Automation/automationAccounts/runbooks/draft@2022-08-08"
  parent_id = azapi_resource.runbook.id
  name      = var.resource_name
}

resource "azapi_update_resource" "draft_1" {
  type      = "Microsoft.Automation/automationAccounts/runbooks/draft@2022-08-08"
  parent_id = azapi_resource.runbook.id
  name      = var.resource_name
  body = jsonencode({
    parameters = {
      key01 = "value01"
      key02 = "value02"
    }
    runOn = ""
  })
}

data "azapi_resource_action" "resume" {
  type        = "Microsoft.Automation/automationAccounts/runbooks/draft@2022-08-08"
  resource_id = azapi_update_resource.draft_1.id
  action      = "resume"
  method      = "POST"
}

data "azapi_resource_action" "stop" {
  type        = "Microsoft.Automation/automationAccounts/runbooks/draft@2022-08-08"
  resource_id = azapi_update_resource.draft_1.id
  action      = "stop"
  method      = "POST"
}

data "azapi_resource_action" "suspend" {
  type        = "Microsoft.Automation/automationAccounts/runbooks/draft@2022-08-08"
  resource_id = azapi_update_resource.draft_1.id
  action      = "suspend"
  method      = "POST"
}

data "azapi_resource_action" "undoEdit" {
  type        = "Microsoft.Automation/automationAccounts/runbooks/draft@2022-08-08"
  resource_id = azapi_update_resource.draft_1.id
  action      = ""
  method      = "POST"
}

data "azapi_resource_list" "listDraftByRunbook" {
  type       = "Microsoft.Automation/automationAccounts/runbooks/draft@2022-08-08"
  parent_id  = azapi_resource.runbook.id
  depends_on = [azapi_update_resource.draft_1]
}

