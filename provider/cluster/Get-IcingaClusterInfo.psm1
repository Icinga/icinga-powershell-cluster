<#
.SYNOPSIS
    Fetch available information on the clustered Servers regarding Failover Cluster information
.DESCRIPTION
    Fetch available information on the clustered Servers regarding Cluster information.
    Returns a hashtable all required data for monitoring the health of Failover Cluster
.ROLE
    WMI Permissions

    * Root\MSCluster
    * Root\Cimv2
.OUTPUTS
    System.Hashtable
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Get-IcingaClusterInfo()
{
    if (-Not (Test-IcingaClusterInstalled)) {
        return @{ };
    }

    $ClusterNodes     = Get-IcingaWindowsInformation -ClassName MSCluster_Node -NameSpace 'Root\MSCluster';
    $ClusterResources = Get-IcingaClusterResource;
    $ClusterData      = @{
        'Nodes' = @{ };
    };

    foreach ($resource in $ClusterResources.Keys) {
        $ClusterResource = $ClusterResources[$resource];
        if ($ClusterResource.Type -eq 'Physical Disk' -OR $ClusterResource.Type -eq 'Virtual Machine Cluster WMI' -OR $ClusterResource.Type -eq 'Storage QoS Policy Manager') {
            continue;
        }

        $ClusterData.Add($resource, $ClusterResource);
    }

    foreach ($node in $ClusterNodes) {
        $NodeDetails = @{
            'Caption'                     = $node.Caption;
            'CreationClassName'           = $node.CreationClassName;
            'InitialLoadInfo'             = $node.InitialLoadInfo;
            'InstallDate'                 = $node.InstallDate;
            'LastLoadInfo'                = $node.LastLoadInfo;
            'Name'                        = $node.Name;
            'NameFormat'                  = $node.NameFormat;
            'OtherIdentifyingInfo'        = $node.OtherIdentifyingInfo;
            'IdentifyingDescriptions'     = $node.IdentifyingDescriptions;
            'Dedicated'                   = $node.Dedicated;
            'PowerManagementCapabilities' = $node.PowerManagementCapabilities;
            'PowerState'                  = $node.PowerState;
            'PrimaryOwnerContact'         = $node.PrimaryOwnerContact;
            'PrimaryOwnerName'            = $node.PrimaryOwnerName;
            'ResetCapability'             = $node.ResetCapability;
            'Roles'                       = $node.Roles;
            'Status'                      = $node.Status;
            'Description'                 = $node.Description;
            'NodeWeight'                  = $node.NodeWeight;
            'DynamicWeight'               = $node.DynamicWeight;
            'NodeHighestVersion'          = $node.NodeHighestVersion;
            'NodeLowestVersion'           = $node.NodeLowestVersion;
            'MajorVersion'                = $node.MajorVersion;
            'MinorVersion'                = $node.MinorVersion;
            'BuildNumber'                 = $node.BuildNumber;
            'CSDVersion'                  = $node.CSDVersion;
            'Id'                          = $node.Id;
            'NodeInstanceID'              = $node.NodeInstanceID;
            'NodeDrainStatus'             = $node.NodeDrainStatus;
            'NodeDrainTarget'             = $node.NodeDrainTarget;
            'State'                       = $node.State;
            'Flags'                       = $node.Flags;
            'Characteristics'             = $node.Characteristics;
            'NeedsPreventQuorum'          = $node.NeedsPreventQuorum;
            'FaultDomainId'               = $node.FaultDomainId;
            'StatusInformation'           = $node.StatusInformation;
            'FaultDomain'                 = $node.FaultDomain;
            'PrivateProperties'           = $node.PrivateProperties;
        };

        $ClusterData.Nodes.Add($node.Name, $NodeDetails);
    }

    return $ClusterData;
}
