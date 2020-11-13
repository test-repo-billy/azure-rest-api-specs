## AzureResourceSchema

These settings apply only when `--azureresourceschema` is specified on the command line.

### AzureResourceSchema multi-api

``` yaml $(azureresourceschema) && $(multiapi)
batch:
  - tag: schema-tianenpubbilling-2020-11-13
  
```

Please also specify `--azureresourceschema-folder=<path to the root directory of your azure-resource-manager-schemas clone>`.

### Tag: schema-tianenpubbilling-2020-11-13 and azureresourceschema

``` yaml $(tag) == 'schema-tianenpubbilling-2020-11-13' && $(azureresourceschema)
output-folder: $(azureresourceschema-folder)/schemas

# all the input files in this apiVersion
input-file:
  - Microsoft.TianenPubBilling/preview/2020-11-13/tianenpubbilling.json
```
