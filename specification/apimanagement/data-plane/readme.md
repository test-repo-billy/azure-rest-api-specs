# apimanagement

> see https://aka.ms/autorest

This is the AutoRest configuration file for apimanagement.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the apimanagement.

```yaml
openapi-type: data-plane
tag: package-2021-06-07.1
```

### Tag: package-2021-06-07.1

These settings apply only when `--tag=package-2021-06-07.1` is specified on the command line.

```yaml $(tag) == 'package-2021-06-07.1'
input-file:
  - Microsoft.ApiManagement/preview/2021-06-07.1/apimanagement.json
```
