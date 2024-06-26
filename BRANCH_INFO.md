This branch was created by kojamroz on 6/26/2024

This branch is expected to trigger cross-version breaking change report between stable version. 
In addition, the TypeSpec requirement check should not trigger.

It differs from main as follows:

## 1. It introduces a new directory:

`specification/alertsmanagement/resource-manager/Microsoft.AlertsManagement/stable/2024-05-01`

which is a copy of:

`specification/alertsmanagement/resource-manager/Microsoft.AlertsManagement/stable/2023-03-01`

## 2. In the new directory the following file:

`specification/alertsmanagement/resource-manager/Microsoft.AlertsManagement/stable/2024-05-01/PrometheusRuleGroups.json`

Differs from its original. Its `operationId` has been changed. It is now:

`"operationId": "CROSS_VER_BREAKING_CHANGE_TEST_PrometheusRuleGroups_ListBySubscription",`

instead of the original:

`"operationId": "PrometheusRuleGroups_ListBySubscription",`

In addition, all files in the newly introduced directory got their `"version"` updated to be `"2024-05-01"`.

## 3. The README:

`specification/alertsmanagement/resource-manager/readme.md`

The default tag has been changed to `package-2024-05` and following entry was added:

> Tag: package-2024-05
> 
> These settings apply only when `--tag=package-2024-05` is specified on the command line.
>
> ```yaml $(tag) == 'package-2023-03'
> input-file:
>   - Microsoft.AlertsManagement/stable/2024-05-01/PrometheusRuleGroups.json
>   - Microsoft.AlertsManagement/preview/2024-01-01-preview/AlertsManagement.json
>   - Microsoft.AlertsManagement/preview/2019-05-05-preview/SmartGroups.json
>   - Microsoft.AlertsManagement/preview/2023-08-01-preview/AlertRuleRecommendations.json
>   - Microsoft.AlertsManagement/preview/2024-03-01-preview/AlertProcessingRules.json
> ```
