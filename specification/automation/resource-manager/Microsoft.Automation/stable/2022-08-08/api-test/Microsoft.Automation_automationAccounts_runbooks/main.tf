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
  default = "East US 2"
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
  type      = "Microsoft.Automation/automationAccounts/runbooks@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    properties = {
      description      = "Description of the Runbook"
      logActivityTrace = 1
      logProgress      = true
      logVerbose       = false
      publishContentLink = {
        contentHash = {
          algorithm = "SHA256"
          value     = "115775B8FF2BE672D8A946BD0B489918C724DDE15A440373CA54461D53010A80"
        }
        uri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-automation-runbook-getvms/Runbooks/Get-AzureVMTutorial.ps1"
      }
      runbookType = "PowerShellWorkflow"
    }
    tags = {
      tag01 = "value01"
      tag02 = "value02"
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_runbook" {
  type        = "Microsoft.Automation/automationAccounts/runbooks@2022-08-08"
  resource_id = azapi_resource.runbook.id
  action      = ""
  method      = "PATCH"
  body = jsonencode({
    properties = {
      description      = "Updated Description of the Runbook"
      logActivityTrace = 1
      logProgress      = true
      logVerbose       = false
    }
  })
}

data "azapi_resource_action" "content" {
  type        = "Microsoft.Automation/automationAccounts/runbooks@2022-08-08"
  resource_id = azapi_resource.runbook.id
  action      = "content"
  method      = "GET"
}

data "azapi_resource_action" "publish" {
  type        = "Microsoft.Automation/automationAccounts/runbooks@2022-08-08"
  resource_id = azapi_resource.runbook.id
  action      = "publish"
  method      = "POST"
}

data "azapi_resource_list" "listRunbooksByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/runbooks@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.runbook]
}

