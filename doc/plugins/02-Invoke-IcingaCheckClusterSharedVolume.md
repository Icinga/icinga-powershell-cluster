
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
| IncludeVolumes | Array | false | @() | Used to Filter out which Cluster Shared Volumes you want to check, provided you have several SharedVolumes on your system. Example ('Cluster disk 2') |
| ExcludeVolumes | Array | false | @() | Used to Filter out which Cluster Shared Volumes you don't want to check, provided you have several SharedVolumes on your system. Example ('Cluster disk 2'). |
| FreeSpaceWarning | Object | false |  | Used to specify a Warning threshold for the SharedVolume free space in %. Example (10) |
| FreeSpaceCritical | Object | false |  | Used to specify a Critical threshold for the SharedVolume free space in %. Example (5) |
| NoPerfData | SwitchParameter | false | False | Disables the performance data output of this plugin |
| Verbosity | Object | false | 0 | Changes the behavior of the plugin output which check states are printed: 0 (default): Only service checks/packages with state not OK will be printed 1: Only services with not OK will be printed including OK checks of affected check packages including Package config 2: Everything will be printed regardless of the check state |

## Examples

### Example Command 1

```powershell
icinga { Invoke-IcingaCheckClusterSharedVolume -Verbosity 2 }
```

### Example Output 1

```powershell
[OK] Check package "Network Volumes Package" (Match All)\_ [OK] Check package "Cluster Resource Package" (Match All) \_ [OK] Cluster Disk 1 Status: Online \_ [OK] Storage Qos Resource Status: Online\_ [OK] Check package "SharedVolume Cluster Disk 2" (Match All) \_ [OK] Cluster Disk 2 Fault State: NoFaults \_ [OK] Cluster Disk 2 FreeSpace: 89.06% \_ [OK] Cluster Disk 2 RedirectedAccess: False \_ [OK] Cluster Disk 2 State: Online \_ [OK] Check package "Members" (Match All)\_ [OK] Check package "SharedVolume Cluster Disk 2 (Node: volume-node1)" (Match All)\_ [OK] Cluster Disk 2 Block RedirectedIOReason: NotBlockRedirected\_ [OK] Cluster Disk 2 FileSystem RedirectedIOReason: NotFileSystemRedirected\_ [OK] Cluster Disk 2 StateInfo: Direct\_ [OK] Check package "SharedVolume Cluster Disk 2 (Node: volume-node2)" (Match All) \_ [OK] Cluster Disk 2 Block RedirectedIOReason: NotBlockRedirected \_ [OK] Cluster Disk 2 FileSystem RedirectedIOReason: NotFileSystemRedirected\_ [OK] Cluster Disk 2 StateInfo: Direct\_ [OK] Check package "SharedVolume Cluster Disk 3" (Match All) \_ [OK] Cluster Disk 3 Fault State: NoFaults \_ [OK] Cluster Disk 3 FreeSpace: 89.06% \_ [OK] Cluster Disk 3 RedirectedAccess: False \_ [OK] Cluster Disk 3 State: Online \_ [OK] Check package "Members" (Match All)\_ [OK] Check package "SharedVolume Cluster Disk 3 (Node: volume-node1)" (Match All)\_ [OK] Cluster Disk 3 Block RedirectedIOReason: NotBlockRedirected\_ [OK] Cluster Disk 3 FileSystem RedirectedIOReason: NotFileSystemRedirected\_ [OK] Cluster Disk 3 StateInfo: Direct \_ [OK] Check package "SharedVolume Cluster Disk 3 (Node: volume-node2)" (Match All)\_ [OK] Cluster Disk 3 Block RedirectedIOReason: NotBlockRedirected\_ [OK] Cluster Disk 3 FileSystem RedirectedIOReason: NotFileSystemRedirected\_ [OK] Cluster Disk 3 StateInfo: Direct| 'cluster_disk_2_freespace'=89.06%;;;0;100 'storage_qos_resource_status'=2;3;4 'cluster_disk_1_status'=2;3;4 'cluster_disk_3_freespace'=89.06%;;;0;100
```
