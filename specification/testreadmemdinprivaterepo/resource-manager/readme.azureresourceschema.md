## AzureResourceSchema

These settings apply only when `--azureresourceschema` is specified on the command line.

### AzureResourceSchema multi-api

``` yaml $(azureresourceschema) && $(multiapi)
batch:
  - tag: schema-testreadmemdinprivaterepo-2020-11-24
  
```

Please also specify `--azureresourceschema-folder=<path to the root directory of your azure-resource-manager-schemas clone>`.

### Tag: schema-testreadmemdinprivaterepo-2020-11-24 and azureresourceschema

``` yaml $(tag) == 'schema-testreadmemdinprivaterepo-2020-11-24' && $(azureresourceschema)
output-folder: $(azureresourceschema-folder)/schemas

# all the input files in this apiVersion
input-file:
  - Microsoft.TestReadmemdInPrivateRepo/preview/2020-11-24/testreadmemdinprivaterepo.json
```
