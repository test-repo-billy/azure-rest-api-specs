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

resource "azapi_resource" "jobSchedule" {
  type      = "Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      parameters = {
        jobscheduletag01 = "jobschedulevalue01"
        jobscheduletag02 = "jobschedulevalue02"
      }
      runbook = {
        name = "TestRunbook"
      }
      schedule = {
        name = "ScheduleNameGoesHere332204b5-debe-4348-a5c7-6357457189f2"
      }
    }
  })
  schema_validation_enabled = false
}

data "azapi_resource_list" "listJobSchedulesByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.jobSchedule]
}

