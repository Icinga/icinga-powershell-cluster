<#
.SYNOPSIS
    Checks the available space on cluster Shared Volumes and additionally the availability
    and state of the targeted Cluster Shared Volume from each Cluster nodes.
.DESCRIPTION
    Checks the available space on cluster Shared Volumes and additionally the availability
    and state of the targeted Cluster Shared Volume from each Cluster nodes. This plugin can only
    run successfully on a Windows Server 2012 or later version. I.e. if you have Windows Server 2008 or older,
    it will unfortunately not work.
.ROLE
    ### WMI Permissions

    * Root\MSCluster
    * Root\Cimv2

    ### Cluster Permissions

    * Full access on cluster ressource
.PARAMETER IncludeVolumes
    Used to Filter out which Cluster Shared Volumes you want to check, provided you have
    several SharedVolumes on your system. Example ('Cluster disk 2')
.PARAMETER ExcludeVolumes
    Used to Filter out which Cluster Shared Volumes you don't want to check, provided you have
    several SharedVolumes on your system. Example ('Cluster disk 2').
.PARAMETER SpaceWarning
    Used to specify a Warning threshold for the SharedVolume, either in % or as byte unit
    Example: 10% or 10GB
.PARAMETER SpaceCritical
    Used to specify a Critical threshold for the SharedVolume, either in % or as byte unit
    Example: 10% or 10GB
.PARAMETER NoPerfData
    Disables the performance data output of this plugin
.PARAMETER Verbosity
    Changes the behavior of the plugin output which check states are printed:
    0 (default): Only service checks/packages with state not OK will be printed
    1: Only services with not OK will be printed including OK checks of affected check packages including Package config
    2: Everything will be printed regardless of the check state
    3: Identical to Verbose 2, but prints in addition the check package configuration e.g (All must be [OK])
.EXAMPLE
    PS> icinga { Invoke-IcingaCheckClusterSharedVolume -Verbosity 2 }
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
.LINK
    https://github.com/Icinga/icinga-powershell-framework
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Invoke-IcingaCheckClusterSharedVolume()
{
    param(
        [array]$IncludeVolumes = @(),
        [array]$ExcludeVolumes = @(),
        $SpaceWarning          = $null,
        $SpaceCritical          = $null,
        [switch]$NoPerfData    = $FALSE,
        [ValidateSet(0, 1, 2, 3)]
        $Verbosity             = 0
    );

    # Create a main CheckPackage under which all other checks will be placed
    $CheckPackage         = New-IcingaCheckPackage -Name 'Network Volumes Package' -OperatorAnd -Verbose $Verbosity -AddSummaryHeader;
    $ResourceCheckPackage = New-IcingaCheckPackage -Name 'Cluster Resource Package' -OperatorAnd -Verbose $Verbosity;
    $GetVolumes           = Get-IcingaClusterSharedVolumeData -IncludeVolumes $IncludeVolumes -ExcludeVolumes $ExcludeVolumes;

    # Test Whether or not the cluster Service is Running, otherwise we can't get any infos about the cluster
    if ($GetVolumes.ContainsKey('Exception') -eq $FALSE) {
        # We go through all keys, which have fetched us from the provider
        foreach ($volume in $GetVolumes.Keys) {
            $VolumeObj          = $GetVolumes[$volume];
            # Create for each individual Cluster SharedVolume and Members
            $VolumeCheckPackage = New-IcingaCheckPackage -Name ([string]::Format('SharedVolume {0}', $volume)) -OperatorAnd -Verbose $Verbosity;
            $MemberCheckPackage = New-IcingaCheckPackage -Name 'Members' -OperatorAnd -Verbose $Verbosity;

            # Create checks for some Cluster Resources
            if ($volume -eq 'Resources') {
                foreach ($resource in $GetVolumes.Resources.Keys) {
                    $ClusterResource = $GetVolumes.Resources[$resource];
                    if ($GetVolumes.ContainsKey($resource)) {
                        continue;
                    }

                    $ResourceCheckPackage.AddCheck(
                        (
                            New-IcingaCheck `
                                -Name ([string]::Format('{0} Status', $resource)) `
                                -Value $ClusterResource.State `
                                -Translation $ClusterProviderEnums.ClusterServiceStateName
                        ).WarnIfMatch(
                            $ClusterProviderEnums.ClusterServiceState.Offline
                        ).CritIfMatch(
                            $ClusterProviderEnums.ClusterServiceState.Failed
                        )
                    );
                }

                continue;
            }

            # Checks for each cluster SharedVolumes
            $VolumeCheckPackage.AddCheck(
                (
                    New-IcingaCheck `
                        -Name ([string]::Format('{0} State', $volume)) `
                        -Value $VolumeObj.State `
                        -NoPerfData
                ).CritIfMatch(
                    'Offline'
                ).CritIfMatch(
                    'Failed'
                )
            );

            # Check whether the SharedVolumeInfo attr is not UNKNOWN, otherwise we can't get Infos for the check that we need
            # and this can lead to an unhandled ERROR when one of the Cluster Disk is offline
            if ($VolumeObj.SharedVolumeInfo.ContainsKey('Unknown') -eq $FALSE) {
                $VolumeCheckPackage.AddCheck(
                    (
                        New-IcingaCheck `
                            -Name ([string]::Format('{0} Used Space', $volume)) `
                            -Value $VolumeObj.SharedVolumeInfo.Partition.UsedSpace `
                            -Unit 'B' `
                            -BaseValue $VolumeObj.SharedVolumeInfo.Partition.Size
                    ).WarnOutOfRange(
                        $SpaceWarning
                    ).CritOutOfRange(
                        $SpaceCritical
                    )
                );

                $VolumeCheckPackage.AddCheck(
                    (
                        New-IcingaCheck `
                            -Name ([string]::Format('{0} Fault State', $volume)) `
                            -Value $VolumeObj.SharedVolumeInfo.FaultState `
                            -NoPerfData
                    ).WarnIfMatch(
                        'InMaintenance'
                    ).CritIfMatch(
                        'NoAccess'
                    )
                );
            }

            # Checks for Cluster SharedVolume members, that are owned by the individual ClusterNodes
            foreach ($node in $VolumeObj.OwnerNode.Keys) {
                $OwnerNode        = $VolumeObj.OwnerNode[$node];
                $NodeCheckPackage = New-IcingaCheckPackage -Name ([string]::Format('SharedVolume {0} (Node: {1})', $volume, $node)) -OperatorAnd -Verbose $Verbosity;

                $NodeCheckPackage.AddCheck(
                    (
                        New-IcingaCheck `
                            -Name ([string]::Format('{0} Block RedirectedIOReason', $volume)) `
                            -Value $OwnerNode.BlockRedirectedIOReason `
                            -NoPerfData
                    ).WarnIfMatch(
                        $ClusterProviderEnums.'StorageSpaceNotAttached'
                    ).CritIfMatch(
                        $ClusterProviderEnums.'NoDiskConnectivity'
                    )
                );

                $NodeCheckPackage.AddCheck(
                    (
                        New-IcingaCheck `
                            -Name ([string]::Format('{0} StateInfo', $volume)) `
                            -Value $OwnerNode.StateInfo `
                            -NoPerfData
                    ).CritIfMatch(
                        'Unavailable'
                    )
                );

                $NodeCheckPackage.AddCheck(
                    (
                        New-IcingaCheck `
                            -Name ([string]::Format('{0} FileSystem RedirectedIOReason', $volume)) `
                            -Value $OwnerNode.FileSystemRedirectedIOReason `
                            -NoPerfData
                    ).WarnIfMatch(
                        $ClusterProviderEnums.'IncompatibleFileSystemFilter'
                    ).CritIfMatch(
                        $ClusterProviderEnums.'IncompatibleVolumeFilter'
                    )
                );

                $MemberCheckPackage.AddCheck($NodeCheckPackage);
            }

            # Check whether we added a Cluster SharedVolume Member Checks
            # if not we don't have to add the empty check to the main CheckPackage
            if ($MemberCheckPackage.HasChecks()) {
                $VolumeCheckPackage.AddCheck($MemberCheckPackage);
            }

            $CheckPackage.AddCheck($VolumeCheckPackage);
        }

        # Check whether we added a Cluster Resources Checks
        if ($ResourceCheckPackage.HasChecks()) {
            $CheckPackage.AddCheck($ResourceCheckPackage);
        }
    } else {
        $IcingaCheck = 'Cluster Health: ';
        if ($ClusterProviderEnums.ClusterExceptionIds.ContainsKey($GetVolumes.Exception)) {
            $IcingaCheck = ([string]::Format('Exception: {0}', $ClusterProviderEnums.ClusterExceptionMessages[$GetVolumes.Exception]));
        } else {
            $IcingaCheck += $TestIcingaWindowsInfoEnums.TestIcingaWindowsInfoText[[int]$GetVolumes.Exception];
        }

        # Enforce the checks to critical in case the cluster service should be stopped
        $CheckPackage.AddCheck(
            (
                New-IcingaCheck `
                    -Name $IcingaCheck `
                    -NoPerfData
            ).SetCritical()
        );
    }

    return (New-IcingaCheckResult -Check $CheckPackage -NoPerfData $NoPerfData -Compile);
}
