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
  default = "acctest8566"
}

variable "location" {
  type    = string
  default = "westeurope"
}

// OperationId: DefaultAccounts_Get
// GET /providers/Microsoft.Purview/getDefaultAccount
data "azapi_resource_action" "getDefaultAccount" {
  type        = "Microsoft.Purview@2021-12-01"
  resource_id = "/providers/Microsoft.Purview"
  action      = "getDefaultAccount"
  method      = "GET"
}

// OperationId: DefaultAccounts_Remove
// POST /providers/Microsoft.Purview/removeDefaultAccount
resource "azapi_resource_action" "removeDefaultAccount" {
  type        = "Microsoft.Purview@2021-12-01"
  resource_id = "/providers/Microsoft.Purview"
  action      = "removeDefaultAccount"
  method      = "POST"
}

// OperationId: DefaultAccounts_Set
// POST /providers/Microsoft.Purview/setDefaultAccount
resource "azapi_resource_action" "setDefaultAccount" {
  type        = "Microsoft.Purview@2021-12-01"
  resource_id = "/providers/Microsoft.Purview"
  action      = "setDefaultAccount"
  method      = "POST"
  body = jsonencode({
    accountName       = "myDefaultAccount"
    resourceGroupName = "rg-1"
    scope             = "12345678-1234-1234-1234-12345678abcd"
    scopeTenantId     = "12345678-1234-1234-1234-12345678abcd"
    scopeType         = "Tenant"
    subscriptionId    = "12345678-1234-1234-1234-12345678aaaa"
  })
}

data "azapi_resource" "subscription" {
  type                   = "Microsoft.Resources/subscriptions@2020-06-01"
  response_export_values = ["*"]
}

data "azapi_resource_id" "subscriptionScopeProvider" {
  type      = "Microsoft.Resources/providers@2020-06-01"
  parent_id = data.azapi_resource.subscription.id
  name      = "Microsoft.Purview"
}

// OperationId: Accounts_CheckNameAvailability
// POST /subscriptions/{subscriptionId}/providers/Microsoft.Purview/checkNameAvailability
resource "azapi_resource_action" "checkNameAvailability" {
  type        = "Microsoft.Purview@2021-12-01"
  resource_id = data.azapi_resource_id.subscriptionScopeProvider.id
  action      = "checkNameAvailability"
  method      = "POST"
  body = jsonencode({
    name = "account1"
    type = "Microsoft.Purview/accounts"
  })
}

