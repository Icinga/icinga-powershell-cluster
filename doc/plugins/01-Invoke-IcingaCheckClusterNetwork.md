# Invoke-IcingaCheckClusterNetwork

## Description



## Permissions

No special permissions required.

## Arguments

| Argument | Type | Required | Default | Description |
| ---      | ---  | ---      | ---     | ---         |
| ExcludeClusterInterface | array | false |  |  |
| IncludeClusterInterface | array | false |  |  |
| NoPerfData | switch | false |  |  |
| Verbosity | Object | false |  |  |
| ThresholdInterval | String |  |  | Change the value your defined threshold checks against from the current value to a collected time threshold of the Icinga for Windows daemon, as described [here](https://icinga.com/docs/icinga-for-windows/latest/doc/service/10-Register-Service-Checks/). An example for this argument would be 1m or 15m which will use the average of 1m or 15m for monitoring. |
