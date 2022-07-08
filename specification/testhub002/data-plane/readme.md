# testhub002

> see https://aka.ms/autorest

This is the AutoRest configuration file for testhub002.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the testhub002.

```yaml
openapi-type: data-plane
tag: package-2022-01-14
```

### Tag: package-2022-01-14

These settings apply only when `--tag=package-2022-01-14` is specified on the command line.

```yaml $(tag) == 'package-2022-01-14'
input-file:
  - Microsoft.testhub002/preview/2022-01-14/testhub002.json
```
