## Ruby

These settings apply only when `--ruby` is specified on the command line.

```yaml
package-name: azure_mgmt_tianxi
package-version: 2020-05-11-beta
azure-arm: true
```

### Tag: package-2020-05-11-beta and ruby

These settings apply only when `--tag=package-2020-05-11-beta --ruby` is specified on the command line.
Please also specify `--ruby-sdks-folder=<path to the root directory of your azure-sdk-for-ruby clone>`.

```yaml $(tag) == 'package-2020-05-11-beta' && $(ruby)
namespace: Microsoft.tianxi
output-folder: $(ruby-sdks-folder)/tianxi
```
