# Invoke-IcingaCheckClusterHealth

## Description

Checks the state and availability of a Cluster Service

Invoke-IcingaCheckClusterHealth checks generally for the state of the Cluster, i.e. it checks if the Cluster
service is running properly, the state of all Cluster Nodes and all Cluster Resources like "Task scheduler",
"Clustername" etc. If the Cluster Main Server fails, the check is automatically CRITICAL, because then the
cluster is no longer available and the cluster service is Stopped.

## Permissions

To execute this plugin you will require to grant the following user permissions.

### WMI Permissions

* Root\MSCluster
* Root\Cimv2

### Cluster Permissions

* Read-Only access on cluster ressource

## Arguments

| Argument | Type | Required | Default | Description |
| ---      | ---  | ---      | ---     | ---         |
| Include | Array | false | @() | Used to specify an array of nodes to include, allows '*' wildcard |
| Exclude | Array | false | @() | Used to specify an array of nodes to exclude, allows '*' wildcard |
| WarningState | Array | false | @() | Allows to specify for which node state the check will throw a warning |
| CriticalState | Array | false | @() | Allows to specify for which node state the check will throw a critical |
| SkipClusterRessource | SwitchParameter | false | False | Removes the Cluster Resources package from the check output if set to true |
| NoPerfData | SwitchParameter | false | False | Disables the performance data output of this plugin |
| Verbosity | Object | false | 0 | Changes the behavior of the plugin output which check states are printed:<br /> 0 (default): Only service checks/packages with state not OK will be printed<br /> 1: Only services with not OK will be printed including OK checks of affected check packages including Package config<br /> 2: Everything will be printed regardless of the check state<br /> 3: Identical to Verbose 2, but prints in addition the check package configuration e.g (All must be [OK]) |
| ThresholdInterval | String |  |  | Change the value your defined threshold checks against from the current value to a collected time threshold of the Icinga for Windows daemon, as described [here](https://icinga.com/docs/icinga-for-windows/latest/doc/110-Installation/06-Collect-Metrics-over-Time/). An example for this argument would be 1m or 15m which will use the average of 1m or 15m for monitoring. |

## Examples

### Example Command 1

```powershell
icinga { Invoke-IcingaCheckClusterHealth -Verbosity 2 }
```

### Example Output 1

```powershell
[OK] Check package "Cluster Services" (Match All)
\_ [OK] ClusSvc Status: Running
\_ [OK] Check package "Cluster Nodes" (Match All)
    \_ [OK] Check package "lcontreras-wind" (Match All)
        \_ [OK] #1 State: Up
        \_ [OK] #1 Status Information: Normal
    \_ [OK] Check package "yhabteab-window" (Match All)
        \_ [OK] #2 State: Up
        \_ [OK] #2 Status Information: Normal
\_ [OK] Check package "Cluster Resources" (Match All)
    \_ [OK] Cluster-IP-Adresse Status: Online
    \_ [OK] Clustername Status: Online
    \_ [OK] Task Scheduler Status: Online
| 'clussvc_status'=4;;4 'clusteripadresse_status'=2;3;4 'clustername_status'=2;3;4 'task_scheduler_status'=2;3;4 '2_status_information'=0;;2 '2_state'=0;-1;2 '1_state'=0;-1;2 '1_status_information'=0;;2
0    
```


