# communicationservices

> see https://aka.ms/autorest

This is the AutoRest configuration file for communicationservices.

## Getting Started

To build the SDKs for My API, simply install AutoRest via `npm` (`npm install -g autorest`) and then run:

> `autorest readme.md`

To see additional help and options, run:

> `autorest --help`

For other options on installation see [Installing AutoRest](https://aka.ms/autorest/install) on the AutoRest github page.

---

## Configuration

### Basic Information

These are the global settings for the communicationservices.

``` yaml
openapi-type: data-plane
tag: package-2024-11-15-preview
```

### Tag: package-2024-11-15-preview

These settings apply only when `--tag=package-2024-11-15-preview` is specified on the command line.

``` yaml $(tag) == 'package-2024-11-15-preview'
input-file:
  - preview/2024-11-15-preview/communicationservicessiprouting.json
title:
  Azure Communication Services
```

### Tag: package-preview-2023-04

These settings apply only when `--tag=package-preview-2023-04` is specified on the command line.

```yaml $(tag) == 'package-preview-2023-04'
input-file:
  - preview/2023-04-01-preview/communicationservicessiprouting.json
```
### Tag: package-2023-03

These settings apply only when `--tag=package-2023-03` is specified on the command line.

``` yaml $(tag) == 'package-2023-03'
input-file:
  - stable/2023-03-01/communicationservicessiprouting.json
```

### Tag: package-2023-01-01-preview

These settings apply only when `--tag=package-2023-01-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2023-01-01-preview'
input-file:
  - preview/2023-01-01-preview/communicationservicessiprouting.json
title:
  Azure Communication Services
```

### Tag: package-2022-10-01-preview

These settings apply only when `--tag=package-2022-10-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2022-10-01-preview'
input-file:
  - preview/2022-10-01-preview/communicationservicessiprouting.json
title:
  Azure Communication Services
```

### Tag: package-2022-09-01-preview

These settings apply only when `--tag=package-2022-09-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2022-09-01-preview'
input-file:
  - preview/2022-09-01-preview/communicationservicessiprouting.json
title:
  Azure Communication Services
```

### Tag: package-2021-05-01-preview

These settings apply only when `--tag=package-2021-05-01-preview` is specified on the command line.

``` yaml $(tag) == 'package-2021-05-01-preview'
input-file:
  - preview/2021-05-01-preview/communicationservicessiprouting.json
title:
  Azure Communication Services
```

---

# Code Generation

## Swagger to SDK

This section describes what SDK should be generated by the automatic system.
This is not used by Autorest itself.

## Python

See configuration in [readme.python.md](./readme.python.md)

## Ruby

See configuration in [readme.ruby.md](./readme.ruby.md)

## TypeScript

See configuration in [readme.typescript.md](./readme.typescript.md)

## CSharp

See configuration in [readme.csharp.md](./readme.csharp.md)
