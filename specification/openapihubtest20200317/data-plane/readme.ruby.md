## Ruby

These settings apply only when `--ruby` is specified on the command line.

```yaml
package-name: azure_mgmt_openapihubtest20200317
package-version: 2020-03-17
azure-arm: true
```

### Tag: package-2020-03-17 and ruby

These settings apply only when `--tag=package-2020-03-17 --ruby` is specified on the command line.
Please also specify `--ruby-sdks-folder=<path to the root directory of your azure-sdk-for-ruby clone>`.

```yaml $(tag) == 'package-2020-03-17' && $(ruby)
namespace: Microsoft.Openapihubtest20200317
output-folder: $(ruby-sdks-folder)/openapihubtest20200317
```
