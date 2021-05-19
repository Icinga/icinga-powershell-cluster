<#
.SYNOPSIS
    Monitors the status of a Cluster network and its interfaces.
.DESCRIPTION
    Invoke-IcingaCheckClusterNetwork monitors the accessibility and status of a Cluster network and the
    Cluster network members interfaces of the individual cluster nodes.
.ROLE
    ### WMI Permissions

    * Root\MSCluster
    * Root\Cimv2

    ### Cluster Permissions

    * Read-Only access on cluster ressource
.PARAMETER IncludeClusterInterface
    Specify the name of the Network Interfaces you want to include for checks. Example 'Ethernet 1, Ethernet'
.PARAMETER ExcludeClusterInterface
    Specify the name of the Network Interfaces you want to exclude from checks. Example 'Ethernet 1, Ethernet'
.PARAMETER NoPerfData
    Disables the performance data output of this plugin.
.PARAMETER Verbosity
    Changes the behavior of the plugin output which check states are printed:
    0 (default): Only service checks/packages with state not OK will be printed
    1: Only services with not OK will be printed including OK checks of affected check packages including Package config
    2: Everything will be printed regardless of the check state
    3: Identical to Verbose 2, but prints in addition the check package configuration e.g (All must be [OK])
.EXAMPLE
    PS> Invoke-IcingaCheckClusterNetwork -Verbosity 2
    [OK] Check package "Cluster Network Package" (Match All)
    \_ [OK] Check package "Network Package" (Match All)
       \_ [OK] Cluster Network 1 Role: Both
       \_ [OK] Cluster Network 1 State: Up
       \_ [OK] Check package "Interfaces Package (Network: Cluster Network 1)" (Match All)
          \_ [OK] cluster-node1 - Ethernet State: Up
          \_ [OK] cluster-node2 - Ethernet State: Up
    | 'cluster_network_1_state'=3;;3 'clusternode1_ethernet_state'=3;;3 'clusternode2_ethernet_state'=3;;3 'cluster_network_1_role'=3;;
    0
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
    https://github.com/Icinga/icinga-powershell-plugins
    https://github.com/Icinga/icinga-powershell-framework
#>

function Invoke-IcingaCheckClusterNetwork()
{
    param(
        [array]$IncludeClusterInterface = @(),
        [array]$ExcludeClusterInterface = @(),
        [switch]$NoPerfData             = $FALSE,
        [ValidateSet(0, 1, 2, 3)]
        $Verbosity                      = 0
    );

    # Create a main CheckPackage under which all other checks will be placed
    $CheckPackage   = New-IcingaCheckPackage -Name 'Cluster Network Package' -OperatorAnd -Verbose $Verbosity -AddSummaryHeader;
    # We obtain all necessary information for the Cluster Network from the provider
    $ClusterNetInfo = Get-IcingaClusterNetworkData -IncludeClusterInterface $IncludeClusterInterface -ExcludeClusterInterface $ExcludeClusterInterface;

    # Check Whether or not the cluster Service is Running, otherwise we can't get any infos about the cluster
    if ($ClusterNetInfo.ContainsKey('Exception') -eq $FALSE) {
        foreach ($ClusterNet in $ClusterNetInfo.Keys) {
            $GetClusterNet         = $ClusterNetInfo[$ClusterNet];
            # Create CheckPackages for each individual Cluster Networks
            $NetworkCheckPackage   = New-IcingaCheckPackage -Name 'Network Package' -OperatorAnd -Verbose $Verbosity;
            $InterfaceCheckPackage = New-IcingaCheckPackage -Name ([string]::Format('Interfaces Package (Network: {0})', $ClusterNet)) -OperatorAnd -Verbose $Verbosity;

            # Add ChecPackage for each Cluster Networks State
            $NetworkCheckPackage.AddCheck(
                (
                    New-IcingaCheck `
                        -Name ([string]::Format('{0} State', $GetClusterNet.Name)) `
                        -Value $GetClusterNet.State `
                        -Translation $ClusterProviderEnums.ClusterNetState
                ).CritIfNotMatch(
                    $ClusterProviderEnums.ClusterNetStateName.Up
                )
            );

            $NetworkCheckPackage.AddCheck(
                (
                    New-IcingaCheck `
                        -Name ([string]::Format('{0} Role', $GetClusterNet.Name)) `
                        -Value $GetClusterNet.Role `
                        -Translation $ClusterProviderEnums.ClusterNetRole
                )
            );

            # Go through all available Cluster Network Interfaces and check their status
            foreach ($interface in $GetClusterNet.Interface.Keys) {
                $ClusterInterface = $GetClusterNet.Interface[$interface];
                $InterfaceCheckPackage.AddCheck(
                    (
                        New-IcingaCheck `
                            -Name ([string]::Format('{0} State', $interface)) `
                            -Value $ClusterInterface.State `
                            -Translation $ClusterProviderEnums.ClusterNetState
                    ).CritIfNotMatch(
                        $ClusterProviderEnums.ClusterNetStateName.Up
                    )
                );
            }

            # Add Interface CheckPackage to the ClusterNetwork Package to which it belongs
            $NetworkCheckPackage.AddCheck($InterfaceCheckPackage);
            $CheckPackage.AddCheck($NetworkCheckPackage);
        }
    } else {
        $IcingaCheck = 'Cluster Health: ';
        if ($ClusterProviderEnums.ClusterExceptionIds.ContainsKey($ClusterNetInfo.Exception)) {
            $IcingaCheck = ([string]::Format('Exception: {0}', $ClusterProviderEnums.ClusterExceptionMessages[$ClusterNetInfo.Exception]));
        } else {
            $IcingaCheck += $TestIcingaWindowsInfoEnums.TestIcingaWindowsInfoText[[int]$ClusterNetInfo.Exception];
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
