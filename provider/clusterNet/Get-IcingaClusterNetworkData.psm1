<#
.SYNOPSIS
    Fetch all available information on the targeted Server regarding Cluster Network information
.DESCRIPTION
    Fetch all available information on the targeted Server regarding Cluster Network information.
    Returns a hashtable all required data for monitoring the health of Cluster Network
.ROLE
    WMI Permissions

    * Root\MSCluster
    * Root\Cimv2

    ### Cluster Permissions

    * Read-Only access on cluster ressources
.OUTPUTS
    System.Hashtable
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Get-IcingaClusterNetworkData()
{
    param(
        [array]$IncludeClusterInterface = @(),
        [array]$ExcludeClusterInterface = @()
    );

    if (-Not (Test-IcingaClusterInstalled)) {
        Exit-IcingaThrowException -ExceptionType 'Custom' -CustomMessage 'Cluster not installed' -InputString 'The Cluster feature is not installed on this system.' -Force;
    }

    # Check whether MSCluster_Network exists on the targeted system
    $TestClasses  = Test-IcingaWindowsInformation -ClassName MSCluster_Network -NameSpace 'Root\MSCluster';
    # Check for error Ids with Binary operators
    $BitWiseCheck = Test-IcingaBinaryOperator -Value $TestClasses -Compare NotSpecified, PermissionError -Namespace $TestIcingaWindowsInfoEnums.TestIcingaWindowsInfo;
    # Get the lasth throw exception id
    $ExceptionId  = Get-IcingaLastExceptionId;
    # We return a empty hashtable if for some reason no data from the WMI classes can be retrieved
    if ($BitWiseCheck) {
        return @{'Exception' = $TestClasses; };
    }

    if ($ClusterProviderEnums.ClusterExceptionIds.ContainsKey($ExceptionId)) {
        return @{'Exception' = $ExceptionId; };
    }

    # Throw an exception when the exception ID is not OK, NotSpecified and PermissionError
    if ($TestClasses -ne $TestIcingaWindowsInfoEnums.TestIcingaWindowsInfo.Ok) {
        Exit-IcingaThrowException `
            -CustomMessage ($TestIcingaWindowsInfoEnums.TestIcingaWindowsInfoExceptionType[[int]$TestClasses]) `
            -InputString ($TestIcingaWindowsInfoEnums.TestIcingaWindowsInfoText[[int]$TestClasses]) `
            -ExceptionType Custom `
            -Force;
    }

    # Check whether or not MSCluster_NetworkInterface exists on the targeted system
    $TestClasses = Test-IcingaWindowsInformation -ClassName MSCluster_NetworkInterface -NameSpace 'Root\MSCluster';
    # Check for error Ids with Binary operators
    $BitWiseCheck = Test-IcingaBinaryOperator -Value $TestClasses -Compare NotSpecified, PermissionError -Namespace $TestIcingaWindowsInfoEnums.TestIcingaWindowsInfo;
    # Get the lasth throw exception id
    $ExceptionId  = Get-IcingaLastExceptionId;
    # We return a empty hashtable if for some reason no data from the WMI classes can be retrieved
    if ($BitWiseCheck) {
        return @{'Exception' = $TestClasses; };
    }

    if ($ClusterProviderEnums.ClusterExceptionIds.ContainsKey($ExceptionId)) {
        return @{'Exception' = $ExceptionId; };
    }

    # Throw an exception when the exception ID is not OK, NotSpecified and PermissionError
    if ($TestClasses -ne $TestIcingaWindowsInfoEnums.TestIcingaWindowsInfo.Ok) {
        Exit-IcingaThrowException `
            -CustomMessage ($TestIcingaWindowsInfoEnums.TestIcingaWindowsInfoExceptionType[[int]$TestClasses]) `
            -InputString ($TestIcingaWindowsInfoEnums.TestIcingaWindowsInfoText[[int]$TestClasses]) `
            -ExceptionType Custom `
            -Force;
    }

    # Get some basic infos to cluster network
    $GetClusterNetInfos     = Get-IcingaWindowsInformation -ClassName MSCluster_Network -Namespace 'Root\MSCluster';
    $GetClusterNetInterface = Get-IcingaWindowsInformation -ClassName MSCluster_NetworkInterface -Namespace 'Root\MSCluster';
    $ClusterNetData         = @{ };

    foreach ($clusternetwork in $GetClusterNetInfos) {
        $details                = @{
            'Caption'           = $clusternetwork.Caption;
            'InstallDate'       = $clusternetwork.InstallDate;
            'Status'            = $clusternetwork.Status;
            'Flags'             = $clusternetwork.Flags;
            'Characteristics'   = $clusternetwork.Characteristics;
            'Name'              = $clusternetwork.Name;
            'ID'                = $clusternetwork.ID;
            'Description'       = $clusternetwork.Description;
            'Address'           = $clusternetwork.Address;
            'AddressMask'       = $clusternetwork.AddressMask;
            'Role'              = $clusternetwork.Role;
            'State'             = $clusternetwork.State;
            'IPv6Addresses'     = $clusternetwork.IPv6Addresses;
            'IPv6PrefixLengths' = $clusternetwork.IPv6PrefixLengths;
            'IPv4Addresses'     = $clusternetwork.IPv4Addresses;
            'IPv4PrefixLengths' = $clusternetwork.IPv4PrefixLengths;
            'Metric'            = $clusternetwork.Metric;
            'AutoMetric'        = $clusternetwork.AutoMetric;
            'PrivateProperties' = $clusternetwork.PrivateProperties;
            'Interface'         = @{};
        };

        foreach ($item in $GetClusterNetInterface) {
            if ($IncludeClusterInterface.Count -ne 0) {
                if ($IncludeClusterInterface.Contains($item.Name) -eq $FALSE) {
                    continue;
                }
            }

            if ($ExcludeClusterInterface.Count -ne 0) {
                if ($ExcludeClusterInterface.Contains($item.Name) -eq $TRUE) {
                    continue;
                }
            }

            if ($clusternetwork.Name -ne $item.Network) {
                continue;
            }

            $Interface = @{
                'Caption'                     = $item.Caption;
                'Status'                      = $item.Status;
                'InstallDate'                 = $item.InstallDate;
                'SystemCreationClassName'     = $item.SystemCreationClassName;
                'SystemName'                  = $item.SystemName;
                'CreationClassName'           = $item.CreationClassName;
                'DeviceID'                    = $item.DeviceID;
                'PowerManagementSupported'    = $item.PowerManagementSupported;
                'PowerManagementCapabilities' = $item.PowerManagementCapabilities;
                'Availability'                = $item.Availability;
                'ConfigManagerErrorCode'      = $item.ConfigManagerErrorCode;
                'ConfigManagerUserConfig'     = $item.ConfigManagerUserConfig;
                'PNPDeviceID'                 = $item.PNPDeviceID;
                'StatusInfo'                  = $item.StatusInfo;
                'LastErrorCode'               = $item.LastErrorCode;
                'ErrorDescription'            = $item.ErrorDescription;
                'ErrorCleared'                = $item.ErrorCleared;
                'OtherIdentifyingInfo'        = $item.OtherIdentifyingInfo;
                'PowerOnHours'                = $item.PowerOnHours;
                'TotalPowerOnHours'           = $item.TotalPowerOnHours;
                'IdentifyingDescriptions'     = $item.IdentifyingDescriptions;
                'Name'                        = $item.Name;
                'Description'                 = $item.Description;
                'Adapter'                     = $item.Adapter;
                'AdapterId'                   = $item.AdapterId;
                'Node'                        = $item.Node;
                'Address'                     = $item.Address;
                'Network'                     = $item.Network;
                'State'                       = $item.State;
                'Flags'                       = $item.Flags;
                'Characteristics'             = $item.Characteristics;
                'IPv6Addresses'               = $item.IPv6Addresses;
                'IPv4Addresses'               = $item.IPv4Addresses;
                'DhcpEnabled'                 = $item.DhcpEnabled;
                'PrivateProperties'           = $item.PrivateProperties;
                'Id'                          = $item.Id;
            };

            $details.Interface.Add($item.Name, $Interface);

            Write-IcingaConsoleDebug -Message ([string]::Format(
                    'Cluster Interface {0}: ConfigManagerErrorCode: {1}.',
                    $item.Name,
                    $ClusterProviderEnums.ClusterInterConfigManagerErrorCode[[int]$item.ConfigManagerErrorCode]
                )
            );

            Write-IcingaConsoleDebug -Message ([string]::Format('Cluster Interface {0}: Availability : {1}',
                    $item.Name,
                    $ClusterProviderEnums.ClusterInterfaceAvailabilityDebug[[int]$item.Availability]
                )
            );
        }

        $ClusterNetData.Add($clusternetwork.Name, $details);
    }

    return $ClusterNetData;
}
