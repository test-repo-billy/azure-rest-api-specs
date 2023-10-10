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

resource "azapi_resource" "python2Package" {
  type      = "Microsoft.Automation/automationAccounts/python2Packages@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      contentLink = {
        contentHash = {
          algorithm = "sha265"
          value     = "07E108A962B81DD9C9BAA89BB47C0F6EE52B29E83758B07795E408D258B2B87A"
        }
        uri     = "https://teststorage.blob.core.windows.net/dsccomposite/OmsCompositeResources.zip"
        version = "1.0.0.0"
      }
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_python2Package" {
  type        = "Microsoft.Automation/automationAccounts/python2Packages@2022-08-08"
  resource_id = azapi_resource.python2Package.id
  action      = ""
  method      = "PATCH"
}

data "azapi_resource_list" "listPython2PackagesByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/python2Packages@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.python2Package]
}

