# Invoke-IcingaCheckClusterNetwork

## Description

Monitors the status of a Cluster network and its interfaces.

Invoke-IcingaCheckClusterNetwork monitors the accessibility and status of a Cluster network and the
Cluster network members interfaces of the individual cluster nodes.

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
| IncludeClusterInterface | Array | false | @() | Specify the name of the Network Interfaces you want to include for checks. Example 'Ethernet 1, Ethernet' |
| ExcludeClusterInterface | Array | false | @() | Specify the name of the Network Interfaces you want to exclude from checks. Example 'Ethernet 1, Ethernet' |
| NoPerfData | SwitchParameter | false | False | Disables the performance data output of this plugin. |
| Verbosity | Object | false | 0 | Changes the behavior of the plugin output which check states are printed:<br /> 0 (default): Only service checks/packages with state not OK will be printed<br /> 1: Only services with not OK will be printed including OK checks of affected check packages including Package config<br /> 2: Everything will be printed regardless of the check state<br /> 3: Identical to Verbose 2, but prints in addition the check package configuration e.g (All must be [OK]) |
| ThresholdInterval | String |  |  | Change the value your defined threshold checks against from the current value to a collected time threshold of the Icinga for Windows daemon, as described [here](https://icinga.com/docs/icinga-for-windows/latest/doc/110-Installation/06-Collect-Metrics-over-Time/). An example for this argument would be 1m or 15m which will use the average of 1m or 15m for monitoring. |

## Examples

### Example Command 1

```powershell
Invoke-IcingaCheckClusterNetwork -Verbosity 2
```

### Example Output 1

```powershell
[OK] Check package "Cluster Network Package" (Match All)
\_ [OK] Check package "Network Package" (Match All)
   \_ [OK] Cluster Network 1 Role: Both
   \_ [OK] Cluster Network 1 State: Up
   \_ [OK] Check package "Interfaces Package (Network: Cluster Network 1)" (Match All)
      \_ [OK] cluster-node1 - Ethernet State: Up
      \_ [OK] cluster-node2 - Ethernet State: Up
| 'cluster_network_1_state'=3;;3 'clusternode1_ethernet_state'=3;;3 'clusternode2_ethernet_state'=3;;3 'cluster_network_1_role'=3;;
0    
```


