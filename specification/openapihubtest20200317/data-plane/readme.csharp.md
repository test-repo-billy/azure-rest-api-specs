## C

These settings apply only when `--csharp` is specified on the command line.
Please also specify `--csharp-sdks-folder=<path to "SDKs" directory of your azure-sdk-for-net clone>`.

```yaml $(csharp)
csharp:
  azure-arm: true
  license-header: MICROSOFT_MIT_NO_VERSION
  payload-flattening-threshold: 1
  clear-output-folder: true
  client-side-validation: false
  namespace: Microsoft.Openapihubtest20200317
  output-folder: $(csharp-sdks-folder)/openapihubtest20200317/management/Microsoft.Openapihubtest20200317/GeneratedProtocol
```
