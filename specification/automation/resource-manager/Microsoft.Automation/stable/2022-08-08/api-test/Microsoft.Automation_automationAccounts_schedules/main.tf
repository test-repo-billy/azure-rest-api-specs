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

resource "azapi_resource" "schedule" {
  type      = "Microsoft.Automation/automationAccounts/schedules@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      advancedSchedule = {
      }
      description = "my description of schedule goes here"
      expiryTime  = "2017-04-01T17:28:57.2494819Z"
      frequency   = "Hour"
      interval    = 1
      startTime   = "2017-03-27T17:28:57.2494819Z"
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_schedule" {
  type        = "Microsoft.Automation/automationAccounts/schedules@2022-08-08"
  resource_id = azapi_resource.schedule.id
  action      = ""
  method      = "PATCH"
  body = jsonencode({
    properties = {
      description = "my updated description of schedule goes here"
      isEnabled   = false
    }
  })
}

data "azapi_resource_list" "listSchedulesByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/schedules@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.schedule]
}

