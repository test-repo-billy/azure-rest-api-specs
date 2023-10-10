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

resource "azapi_resource" "sourceControl" {
  type      = "Microsoft.Automation/automationAccounts/sourceControls@2022-08-08"
  parent_id = azapi_resource.automationAccount.id
  name      = var.resource_name
  body = jsonencode({
    properties = {
      autoSync       = true
      branch         = "master"
      description    = "my description"
      folderPath     = "/folderOne/folderTwo"
      publishRunbook = true
      repoUrl        = "https://sampleUser.visualstudio.com/myProject/_git/myRepository"
      securityToken = {
        accessToken = "******"
        tokenType   = "PersonalAccessToken"
      }
      sourceType = "VsoGit"
    }
  })
  schema_validation_enabled = false
}

resource "azapi_resource_action" "patch_sourceControl" {
  type        = "Microsoft.Automation/automationAccounts/sourceControls@2022-08-08"
  resource_id = azapi_resource.sourceControl.id
  action      = ""
  method      = "PATCH"
  body = jsonencode({
    properties = {
      autoSync       = true
      branch         = "master"
      description    = "my description"
      folderPath     = "/folderOne/folderTwo"
      publishRunbook = true
      securityToken = {
        accessToken = "******"
        tokenType   = "PersonalAccessToken"
      }
    }
  })
}

data "azapi_resource_list" "listSourceControlsByAutomationAccount" {
  type       = "Microsoft.Automation/automationAccounts/sourceControls@2022-08-08"
  parent_id  = azapi_resource.automationAccount.id
  depends_on = [azapi_resource.sourceControl]
}

