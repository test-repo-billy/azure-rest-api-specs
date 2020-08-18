## Python

These settings apply only when `--python` is specified on the command line.
Please also specify `--python-sdks-folder=<path to the root directory of your azure-sdk-for-python clone>`.

```yaml $(python)
python:
  azure-arm: true
  license-header: MICROSOFT_MIT_NO_VERSION
  payload-flattening-threshold: 2
  namespace: Microsoft.Test20200706
  package-name: test20200706
  package-version: 2020-07-06
  clear-output-folder: true
```

```yaml $(python)
python:
  no-namespace-folders: true
  output-folder: $(python-sdks-folder)/azure-mgmt/test20200706
```
