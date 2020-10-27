<#
.SYNOPSIS
    Fetch all information on the targeted Server regarding Cluster Resources.
    Returns a hashtable with all required data for monitoring the health of Cluster Resources.
.ROLE
    ### WMI Permissions

    * Root\MSCluster
    * Root\Cimv2

    ### Cluster Permissions

    * Read-Only access on cluster ressources
.OUTPUTS
    System.Hashtable
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Get-IcingaClusterResource()
{
    $ClusterResources = Get-IcingaWindowsInformation -ClassName MSCluster_Resource -Namespace 'Root\MSCluster';
    $ClusterData      = @{ };

    foreach ($resource in $ClusterResources) {
        $details = @{
            'Caption'                   = $resource.Caption;
            'Description'               = $resource.Description;
            'InstallDate'               = $resource.InstallDate;
            'Name'                      = $resource.Name;
            'Status'                    = $resource.Status;
            'Characteristics'           = $resource.Characteristics;
            'Flags'                     = $resource.Flags;
            'CoreResource'              = $resource.CoreResource;
            'CryptoCheckpoints'         = $resource.CryptoCheckpoints;
            'DeadlockTimeout'           = $resource.DeadlockTimeout;
            'DeleteRequiresAllNodes'    = $resource.DeleteRequiresAllNodes;
            'EmbeddedFailureAction'     = $resource.EmbeddedFailureAction;
            'Id'                        = $resource.Id;
            'IsAlivePollInterval'       = $resource.IsAlivePollInterval;
            'IsClusterSharedVolume'     = $resource.IsClusterSharedVolume;
            'LastOperationStatusCode'   = $resource.LastOperationStatusCode;
            'LocalQuorumCapable'        = $resource.LocalQuorumCapable;
            'LooksAlivePollInterval'    = $resource.LooksAlivePollInterval;
            'MonitorProcessId'          = $resource.MonitorProcessId;
            'OwnerGroup'                = $resource.OwnerGroup;
            'OwnerNode'                 = $resource.OwnerNode;
            'PendingTimeout'            = $resource.PendingTimeout;
            'PersistentState'           = $resource.PersistentState;
            'PrivateProperties'         = $resource.PrivateProperties;
            'QuorumCapable'             = $resource.QuorumCapable;
            'RegistryCheckpoints'       = $resource.RegistryCheckpoints;
            'RequiredDependencyClasses' = $resource.RequiredDependencyClasses;
            'RequiredDependencyTypes'   = $resource.RequiredDependencyTypes;
            'ResourceClass'             = $resource.ResourceClass;
            'ResourceSpecificData1'     = $resource.ResourceSpecificData1;
            'ResourceSpecificData2'     = $resource.ResourceSpecificData2;
            'ResourceSpecificStatus'    = $resource.ResourceSpecificStatus;
            'RestartAction'             = $resource.RestartAction;
            'RestartDelay'              = $resource.RestartDelay;
            'RestartPeriod'             = $resource.RestartPeriod;
            'RestartThreshold'          = $resource.RestartThreshold;
            'RetryPeriodOnFailure'      = $resource.RetryPeriodOnFailure;
            'SeparateMonitor'           = $resource.SeparateMonitor;
            'State'                     = $resource.State;
            'StatusInformation'         = $resource.StatusInformation;
            'Subclass'                  = $resource.Subclass;
            'Type'                      = $resource.Type;
            'PSComputerName'            = $resource.PSComputerName;
        };

        $ClusterData.Add($resource.Name, $details);
    }

    return $ClusterData;
}
