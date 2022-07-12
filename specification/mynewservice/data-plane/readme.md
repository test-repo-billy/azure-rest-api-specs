# mynewservice

> see https://aka.ms/autorest

This is the AutoRest configuration file for mynewservice.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the mynewservice.

```yaml
openapi-type: data-plane
tag: package-2022-07-12-preview
```

### Tag: package-2022-07-12-preview

These settings apply only when `--tag=package-2022-07-12-preview` is specified on the command line.

```yaml $(tag) == 'package-2022-07-12-preview'
input-file:
  - Microsoft.Demo/preview/2022-07-12-preview/mynewservice.json
```
