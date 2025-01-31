# Invoke-IcingaCheckClusterSharedVolume

## Description

Checks the available space on cluster Shared Volumes and additionally the availability
and state of the targeted Cluster Shared Volume from each Cluster nodes.

Checks the available space on cluster Shared Volumes and additionally the availability
and state of the targeted Cluster Shared Volume from each Cluster nodes. This plugin can only
run successfully on a Windows Server 2012 or later version. I.e. if you have Windows Server 2008 or older,
it will unfortunately not work.

## Permissions

To execute this plugin you will require to grant the following user permissions.

### WMI Permissions

* Root\MSCluster
* Root\Cimv2

### Cluster Permissions

* Full access on cluster ressource

## Arguments

| Argument | Type | Required | Default | Description |
| ---      | ---  | ---      | ---     | ---         |
| IncludeVolumes | Array | false | @() | Used to Filter out which Cluster Shared Volumes you want to check, provided you have<br /> several SharedVolumes on your system. Example ('Cluster disk 2') |
| ExcludeVolumes | Array | false | @() | Used to Filter out which Cluster Shared Volumes you don't want to check, provided you have<br /> several SharedVolumes on your system. Example ('Cluster disk 2'). |
| SpaceWarning | Object | false |  | Used to specify a Warning threshold for the SharedVolume, either in % or as byte unit<br /> Example: 10% or 10GB |
| SpaceCritical | Object | false |  | Used to specify a Critical threshold for the SharedVolume, either in % or as byte unit<br /> Example: 10% or 10GB |
| NoPerfData | SwitchParameter | false | False | Disables the performance data output of this plugin |
| Verbosity | Object | false | 0 | Changes the behavior of the plugin output which check states are printed:<br /> 0 (default): Only service checks/packages with state not OK will be printed<br /> 1: Only services with not OK will be printed including OK checks of affected check packages including Package config<br /> 2: Everything will be printed regardless of the check state<br /> 3: Identical to Verbose 2, but prints in addition the check package configuration e.g (All must be [OK]) |
| ThresholdInterval | String |  |  | Change the value your defined threshold checks against from the current value to a collected time threshold of the Icinga for Windows daemon, as described [here](https://icinga.com/docs/icinga-for-windows/latest/doc/110-Installation/06-Collect-Metrics-over-Time/). An example for this argument would be 1m or 15m which will use the average of 1m or 15m for monitoring. |

## Examples

### Example Command 1

```powershell
icinga { Invoke-IcingaCheckClusterSharedVolume -Verbosity 2 }
```

### Example Output 1

```powershell
[OK] Check package "Network Volumes Package" (Match All)
\_ [OK] Check package "Cluster Resource Package" (Match All)
   \_ [OK] Cluster Disk 1 Status: Online
   \_ [OK] Storage Qos Resource Status: Online
\_ [OK] Check package "SharedVolume Cluster Disk 2" (Match All)
   \_ [OK] Cluster Disk 2 Fault State: NoFaults
   \_ [OK] Cluster Disk 2 Used Space: 245GB
   \_ [OK] Cluster Disk 2 RedirectedAccess: False
   \_ [OK] Cluster Disk 2 State: Online
   \_ [OK] Check package "Members" (Match All)
      \_ [OK] Check package "SharedVolume Cluster Disk 2 (Node: volume-node1)" (Match All)
      \_ [OK] Cluster Disk 2 Block RedirectedIOReason: NotBlockRedirected
      \_ [OK] Cluster Disk 2 FileSystem RedirectedIOReason: NotFileSystemRedirected
      \_ [OK] Cluster Disk 2 StateInfo: Direct
    \_ [OK] Check package "SharedVolume Cluster Disk 2 (Node: volume-node2)" (Match All)
       \_ [OK] Cluster Disk 2 Block RedirectedIOReason: NotBlockRedirected
       \_ [OK] Cluster Disk 2 FileSystem RedirectedIOReason: NotFileSystemRedirected
    \_ [OK] Cluster Disk 2 StateInfo: Direct
\_ [OK] Check package "SharedVolume Cluster Disk 3" (Match All)
   \_ [OK] Cluster Disk 3 Fault State: NoFaults
   \_ [OK] Cluster Disk 3 Used Space: 245GB
   \_ [OK] Cluster Disk 3 RedirectedAccess: False
   \_ [OK] Cluster Disk 3 State: Online
   \_ [OK] Check package "Members" (Match All)
      \_ [OK] Check package "SharedVolume Cluster Disk 3 (Node: volume-node1)" (Match All)
      \_ [OK] Cluster Disk 3 Block RedirectedIOReason: NotBlockRedirected
      \_ [OK] Cluster Disk 3 FileSystem RedirectedIOReason: NotFileSystemRedirected
      \_ [OK] Cluster Disk 3 StateInfo: Direct
   \_ [OK] Check package "SharedVolume Cluster Disk 3 (Node: volume-node2)" (Match All)
      \_ [OK] Cluster Disk 3 Block RedirectedIOReason: NotBlockRedirected
      \_ [OK] Cluster Disk 3 FileSystem RedirectedIOReason: NotFileSystemRedirected
      \_ [OK] Cluster Disk 3 StateInfo: Direct
| 'cluster_disk_2_used_space'=245000000000B;;; 'storage_qos_resource_status'=2;3;4 'cluster_disk_1_status'=2;3;4 'cluster_disk_3_used_space'=245000000000B;;;    
```


