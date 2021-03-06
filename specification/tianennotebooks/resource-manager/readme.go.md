## Go

These settings apply only when `--go` is specified on the command line.

```yaml $(go)
go:
  license-header: MICROSOFT_MIT_NO_VERSION
  namespace: tianennotebooks
  clear-output-folder: true
```

### Go multi-api

``` yaml $(go) && $(multiapi)
batch:
  - tag: package-2021-04-27.1408[[-ReleaseState]]
```

### Tag: package-2021-04-27.1408[[-ReleaseState]] and go

These settings apply only when `--tag=package-2021-04-27.1408[[-ReleaseState]] --go` is specified on the command line.
Please also specify `--go-sdk-folder=<path to the root directory of your azure-sdk-for-go clone>`.

```yaml $(tag) == 'package-2021-04-27.1408[[-ReleaseState]]' && $(go)
output-folder: $(go-sdk-folder)/services[[/ReleaseState]]/$(namespace)/mgmt/2021-04-27.1408/$(namespace)
```
