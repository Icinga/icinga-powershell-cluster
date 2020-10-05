<#
.SYNOPSIS
    Tests if the ClusSvc service is installed which indicates if the Failover
    Cluster is installed on the system without requiring administrative privileges
.DESCRIPTION
    Tests if the ClusSvc service is installed which indicates if the Failover
    Cluster is installed on the system without requiring administrative privileges
.OUTPUTS
    System.Boolean | Throws an Icinga Exception
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Test-IcingaClusterInstalled()
{
    $service = Get-Service -Name 'ClusSvc' -ErrorAction SilentlyContinue;

    if ($null -eq $service) {
        Exit-IcingaThrowException -ExceptionType 'Custom' -CustomMessage 'Cluster not installed' -InputString 'The Cluster feature is not installed on this system.' -Force;
    }

    if ($service.Status -ne $ProviderEnums.ServiceStatus.Running) {
        return $FALSE;
    }

    return $TRUE;
}
