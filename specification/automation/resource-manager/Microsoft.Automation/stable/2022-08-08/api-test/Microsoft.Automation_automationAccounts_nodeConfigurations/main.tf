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

resource "azapi_resource" "nodeConfiguration" {
  type      = "Microsoft.Automation/automationAccounts/nodeConfigurations@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      configuration = {
        name = "configName"
      }
      incrementNodeConfigurationBuild = true
      source = {
        hash = {
          algorithm = "sha256"
          value     = "6DE256A57F01BFA29B88696D5E77A383D6E61484C7686E8DB955FA10ACE9FFE5"
        }
        type    = "embeddedContent"
        value   = "\r\ninstance of MSFT_RoleResource as $MSFT_RoleResource1ref\r\n{\r\nResourceID = \"[WindowsFeature]IIS\";\r\n Ensure = \"Present\";\r\n SourceInfo = \"::3::32::WindowsFeature\";\r\n Name = \"Web-Server\";\r\n ModuleName = \"PsDesiredStateConfiguration\";\r\n\r\nModuleVersion = \"1.0\";\r\r\n ConfigurationName = \"configName\";\r\r\n};\r\ninstance of OMI_ConfigurationDocument\r\n\r\r\n                    {\r\n Version=\"2.0.0\";\r\n \r\r\n                        MinimumCompatibleVersion = \"1.0.0\";\r\n \r\r\n                        CompatibleVersionAdditionalProperties= {\"Omi_BaseResource:ConfigurationName\"};\r\n \r\r\n                        Author=\"weijiel\";\r\n \r\r\n                        GenerationDate=\"03/30/2017 13:40:25\";\r\n \r\r\n                        GenerationHost=\"TEST-BACKEND\";\r\n \r\r\n                        Name=\"configName\";\r\n\r\r\n                    };\r\n"
        version = "1.0"
      }
    }
  })
  schema_validation_enabled = false
}

data "azapi_resource_list" "listNodeConfigurationsByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/nodeConfigurations@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.nodeConfiguration]
}

