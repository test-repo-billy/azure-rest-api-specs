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

resource "azapi_resource" "configuration" {
  type      = "Microsoft.Automation/automationAccounts/configurations@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  location  = var.location
  body = jsonencode({
    properties = {
      description = "sample configuration"
      source = {
        hash = {
          algorithm = "sha256"
          value     = "A9E5DB56BA21513F61E0B3868816FDC6D4DF5131F5617D7FF0D769674BD5072F"
        }
        type  = "embeddedContent"
        value = "Configuration SetupServer {\r\n    Node localhost {\r\n                               WindowsFeature IIS {\r\n                               Name = \"Web-Server\";\r\n            Ensure = \"Present\"\r\n        }\r\n    }\r\n}"
      }
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_configuration" {
  type        = "Microsoft.Automation/automationAccounts/configurations@2022-08-08"
  resource_id = azapi_resource.configuration.id
  action      = ""
  method      = "PATCH"
  body = jsonencode({
    tags = {
      Hello = "World"
    }
  })
}

data "azapi_resource_action" "content" {
  type        = "Microsoft.Automation/automationAccounts/configurations@2022-08-08"
  resource_id = azapi_resource.configuration.id
  action      = "content"
  method      = "GET"
}

data "azapi_resource_list" "listConfigurationsByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/configurations@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.configuration]
}

