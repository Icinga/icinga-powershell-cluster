function Test-IcingaClusterInstalled()
{
    if (-Not (Get-Service -Name 'ClusSvc' -ErrorAction SilentlyContinue)) {
        Exit-IcingaThrowException -ExceptionType 'Custom' -CustomMessage 'Package Finder' -InputString 'The Cluster feature is not installed on this system.' -Force;
    }

    $service = Get-Service Get-Service -Name 'ClusSvc';
    if ($service.Status -ne $ProviderEnums.ServiceStatus.Running) {
        return $False;
    }

    return $TRUE;
}
