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
  default = "acctest0003"
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
  type      = "Microsoft.Automation/automationAccounts@2022-08-08"
  parent_id = azapi_resource.resourceGroup.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    properties = {
      sku = {
        name = "Free"
      }
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_automationAccount" {
  type        = "Microsoft.Automation/automationAccounts@2022-08-08"
  resource_id = azapi_resource.automationAccount.id
  action      = ""
  method      = "PATCH"
  body = jsonencode({
    properties = {
      sku = {
        name = "Free"
      }
    }
  })
}

data "azapi_resource_action" "listKeys" {
  type        = "Microsoft.Automation/automationAccounts@2022-08-08"
  resource_id = azapi_resource.automationAccount.id
  action      = "listKeys"
  method      = "POST"
}

data "azapi_resource_action" "statistics" {
  type        = "Microsoft.Automation/automationAccounts@2022-08-08"
  resource_id = azapi_resource.automationAccount.id
  action      = "statistics"
  method      = "GET"
}

data "azapi_resource_action" "usages" {
  type        = "Microsoft.Automation/automationAccounts@2022-08-08"
  resource_id = azapi_resource.automationAccount.id
  action      = "usages"
  method      = "GET"
}

data "azapi_resource_action" "linkedWorkspace" {
  type        = "Microsoft.Automation/automationAccounts@2022-08-08"
  resource_id = azapi_resource.automationAccount.id
  action      = "linkedWorkspace"
  method      = "GET"
}

data "azapi_resource" "subscription" {
  type                   = "Microsoft.Resources/subscriptions@2020-06-01"
  response_export_values = ["*"]
}

data "azapi_resource_list" "listAutomationAccountsBySubscription" {
  type       = "Microsoft.Automation/automationAccounts@2022-08-08"
  parent_id  = data.azapi_resource.subscription.id
  depends_on = [azapi_resource.automationAccount]
}

data "azapi_resource_list" "listAutomationAccountsByResourceGroup" {
  type       = "Microsoft.Automation/automationAccounts@2022-08-08"
  parent_id  = azapi_resource.resourceGroup.id
  depends_on = [azapi_resource.automationAccount]
}

