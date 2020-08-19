## Ruby

These settings apply only when `--ruby` is specified on the command line.

```yaml
package-name: azure_mgmt_wicresoftone
package-version: 2020-08-19
azure-arm: true
```

### Tag: package-2020-08-19 and ruby

These settings apply only when `--tag=package-2020-08-19 --ruby` is specified on the command line.
Please also specify `--ruby-sdks-folder=<path to the root directory of your azure-sdk-for-ruby clone>`.

```yaml $(tag) == 'package-2020-08-19' && $(ruby)
namespace: Microsoft.WcresoftOne
output-folder: $(ruby-sdks-folder)/wicresoftone
```
