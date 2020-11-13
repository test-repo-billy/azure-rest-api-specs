## Python

These settings apply only when `--python` is specified on the command line.
Please also specify `--python-sdks-folder=<path to the root directory of your azure-sdk-for-python clone>`.

``` yaml $(python)
azure-arm: true
license-header: MICROSOFT_MIT_NO_VERSION
package-name: azure-mgmt-tianenpubbilling
no-namespace-folders: true
package-version: 1.0.0b1
```

``` yaml $(python-mode) == 'update'
output-folder: $(python-sdks-folder)/tianenpubbilling/azure-mgmt-tianenpubbilling/azure/mgmt/tianenpubbilling
```
``` yaml $(python-mode) == 'create'
basic-setup-py: true
output-folder: $(python-sdks-folder)/tianenpubbilling/azure-mgmt-tianenpubbilling
```
