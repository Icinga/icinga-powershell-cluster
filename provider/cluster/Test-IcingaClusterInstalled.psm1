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
    if (-Not (Get-Service -Name 'ClusSvc' -ErrorAction SilentlyContinue)) {
        Exit-IcingaThrowException -ExceptionType 'Custom' -CustomMessage 'Package Finder' -InputString 'The Cluster feature is not installed on this system.' -Force;
    }

    $service = Get-Service -Name 'ClusSvc';
    if ($service.Status -ne $ProviderEnums.ServiceStatus.Running) {
        return $False;
    }

    return $TRUE;
}
