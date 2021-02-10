## AzureResourceSchema

These settings apply only when `--azureresourceschema` is specified on the command line.

### AzureResourceSchema multi-api

``` yaml $(azureresourceschema) && $(multiapi)
batch:
  - tag: schema-tianenalertsmanagement-2021-02-10
  
```

Please also specify `--azureresourceschema-folder=<path to the root directory of your azure-resource-manager-schemas clone>`.

### Tag: schema-tianenalertsmanagement-2021-02-10 and azureresourceschema

``` yaml $(tag) == 'schema-tianenalertsmanagement-2021-02-10' && $(azureresourceschema)
output-folder: $(azureresourceschema-folder)/schemas

# all the input files in this apiVersion
input-file:
  - Microsoft.TianenAlertsManagement/preview/2021-02-10/tianenalertsmanagement.json
```
