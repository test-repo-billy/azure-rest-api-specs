## AzureResourceSchema

These settings apply only when `--azureresourceschema` is specified on the command line.

### AzureResourceSchema multi-api

``` yaml $(azureresourceschema) && $(multiapi)
batch:
  - tag: schema-tianennewpubadvisor-2020-11-12
  
```

Please also specify `--azureresourceschema-folder=<path to the root directory of your azure-resource-manager-schemas clone>`.

### Tag: schema-tianennewpubadvisor-2020-11-12 and azureresourceschema

``` yaml $(tag) == 'schema-tianennewpubadvisor-2020-11-12' && $(azureresourceschema)
output-folder: $(azureresourceschema-folder)/schemas

# all the input files in this apiVersion
input-file:
  - Microsoft.TianenNewAdvisor/preview/2020-11-12/tianennewpubadvisor.json
```
