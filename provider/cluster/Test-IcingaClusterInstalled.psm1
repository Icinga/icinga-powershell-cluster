<#
.SYNOPSIS
    Tests if the Failover-Cluster windows feature is installed on the system without requiring administrative privileges
.DESCRIPTION
    Tests if the Failover-Cluster windows feature is installed on the system without requiring administrative privileges
.OUTPUTS
    System.Boolean
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Test-IcingaClusterInstalled()
{
    if (Test-IcingaFunction 'Get-WindowsFeature') {
        if ((Get-WindowsFeature -Name Failover-Clustering).Installed) {
            return $TRUE;
        }
    }

    return $FALSE;
}
