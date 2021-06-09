<#
.SYNOPSIS
    Checks the state and availability of a Cluster Service
.DESCRIPTION
    Invoke-IcingaCheckClusterHealth checks generally for the state of the Cluster, i.e. it checks if the Cluster
    service is running properly, the state of all Cluster Nodes and all Cluster Resources like "Task scheduler",
    "Clustername" etc. If the Cluster Main Server fails, the check is automatically CRITICAL, because then the
    cluster is no longer available and the cluster service is Stopped.
.ROLE
    ### WMI Permissions

    * Root\MSCluster
    * Root\Cimv2

    ### Cluster Permissions

    * Read-Only access on cluster ressource
.PARAMETER WarningState
    Allows to specify for which node state the check will throw a warning
.PARAMETER CriticalState
    Allows to specify for which node state the check will throw a critical
.PARAMETER NoPerfData
    Disables the performance data output of this plugin
.PARAMETER Verbosity
    Changes the behavior of the plugin output which check states are printed:
    0 (default): Only service checks/packages with state not OK will be printed
    1: Only services with not OK will be printed including OK checks of affected check packages including Package config
    2: Everything will be printed regardless of the check state
    3: Identical to Verbose 2, but prints in addition the check package configuration e.g (All must be [OK])
.EXAMPLE
    PS> icinga { Invoke-IcingaCheckClusterHealth -Verbosity 2 }
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
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Invoke-IcingaCheckClusterHealth()
{
    param (
        [ValidateSet('Unknown', 'Up', 'Down', 'Paused', 'Joining')]
        [array]$WarningState  = @(),
        [ValidateSet('Unknown', 'Up', 'Down', 'Paused', 'Joining')]
        [array]$CriticalState = @(),
        [switch]$NoPerfData   = $FALSE,
        [ValidateSet(0, 1, 2, 3)]
        $Verbosity            = 0
    );

    # Create a main CheckPackage under which all other checks will be placed
    $CheckPackage       = New-IcingaCheckPackage -Name 'Cluster Services' -OperatorAnd -Verbose $Verbosity -AddSummaryHeader;
    $ClusterServiceInfo = Get-IcingaClusterInfo;

    # Test Whether or not the cluster Service is Running, otherwise we can't get any infos about the cluster
    if ($ClusterServiceInfo.ContainsKey('Exception') -eq $FALSE) {
        # Create CheckPackages and get cluster infos from the provider
        $ResourceCheckPackage     = New-IcingaCheckPackage -Name 'Cluster Resources' -OperatorAnd -Verbose $Verbosity;
        $ClusterNodesCheckPackage = New-IcingaCheckPackage -Name 'Cluster Nodes' -OperatorAnd -Verbose $Verbosity;
        $GetClusServices          = Get-IcingaServices -Service 'ClusSvc';

        # Check for the cluster Service status
        $CheckPackage.AddCheck(
            (
                New-IcingaCheck `
                    -Name 'Cluster Service Status' `
                    -Value $GetClusServices.Values.configuration.Status.raw `
                    -Translation $ProviderEnums.ServiceStatusName
            ).CritIfNotMatch(
                $ProviderEnums.ServiceStatus.Running
            )
        );

        # We go through all keys, which have fetched us from the provider
        foreach ($service in $ClusterServiceInfo.Keys) {
            $ClusterResource = $ClusterServiceInfo[$service];
            # Check whether or not the Key "Node" is available at the provider information
            if ($service -eq 'Nodes') {
                # Iterate through all Cluster nodes and get their states
                foreach ($node in $ClusterServiceInfo.Nodes.Keys) {
                    $ClusterNode = $ClusterServiceInfo.Nodes[$node];
                    $NodeCheckPackage = New-IcingaCheckPackage -Name $node -OperatorAnd -Verbose $Verbosity;
                    $NodeCheckPackage.AddCheck(
                        (
                            New-IcingaCheck `
                                -Name ([string]::Format('#{0} Status Information', $ClusterNode.Id)) `
                                -Value $ClusterNode.StatusInformation `
                                -Translation $ClusterProviderEnums.ClusterNodeStatusInfo
                        ).CritIfMatch(
                            $ClusterProviderEnums.ClusterNodeStatusInfoName.Quarantined
                        )
                    );

                    $ClusterStateCheck = New-IcingaCheck `
                        -Name ([string]::Format('#{0} State', $ClusterNode.Id)) `
                        -Value $ClusterNode.State `
                        -Translation $ClusterProviderEnums.ClusterNodeState;

                    foreach ($entry in $WarningState) {
                        $WarningClusterState = $ClusterProviderEnums.ClusterNodeStateName[$entry];
                        if ($ClusterNode.State -eq $WarningClusterState) {
                            $ClusterStateCheck.SetWarning(
                                [string]::Format(
                                    'Value {0} is matching values {1}',
                                    ($ClusterProviderEnums.ClusterNodeState[$ClusterNode.State]),
                                    [string]::Join(', ', $WarningState),
                                    $TRUE
                                )
                            ) | Out-Null;
                            break;
                        }
                    }
                    foreach ($entry in $CriticalState) {
                        $CriticalClusterState = $ClusterProviderEnums.ClusterNodeStateName[$entry];
                        if ($ClusterNode.State -eq $CriticalClusterState) {
                            $ClusterStateCheck.SetCritical(
                                [string]::Format(
                                    'Value {0} is matching values {1}',
                                    ($ClusterProviderEnums.ClusterNodeState[$ClusterNode.State]),
                                    [string]::Join(', ', $CriticalState),
                                    $TRUE
                                )
                            ) | Out-Null;
                            break;
                        }
                    }

                    $NodeCheckPackage.AddCheck($ClusterStateCheck);

                    $ClusterNodesCheckPackage.AddCheck($NodeCheckPackage);
                }

                continue;
            }

            # CheckPackage for the Cluster Resources e.g. (Cluster-IP-Adresse Status: )
            $ResourceCheckPackage.AddCheck(
                (
                    New-IcingaCheck `
                        -Name ([string]::Format('{0} Status', $service)) `
                        -Value $ClusterResource.State `
                        -Translation $ClusterProviderEnums.ClusterServiceStateName
                ).WarnIfMatch(
                    $ClusterProviderEnums.ClusterServiceState.Offline
                ).CritIfMatch(
                    $ClusterProviderEnums.ClusterServiceState.Failed
                )
            );
        }

        # Check whether we added a Cluster Resource Checks
        # if not we don't have to add the empty check to the main CheckPackage
        if ($ResourceCheckPackage.HasChecks()) {
            $CheckPackage.AddCheck($ResourceCheckPackage);
        }

        # Check whether we added a Cluster Node Checks
        if ($ClusterNodesCheckPackage.HasChecks()) {
            $CheckPackage.AddCheck($ClusterNodesCheckPackage);
        }
    } else {
        $IcingaCheck = 'Cluster Health: ';
        if ($ClusterProviderEnums.ClusterExceptionIds.ContainsKey($ClusterServiceInfo.Exception)) {
            $IcingaCheck = ([string]::Format('Exception: {0}', $ClusterProviderEnums.ClusterExceptionMessages[$ClusterServiceInfo.Exception]));
        } else {
            $IcingaCheck += $TestIcingaWindowsInfoEnums.TestIcingaWindowsInfoText[[int]$ClusterServiceInfo.Exception];
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
