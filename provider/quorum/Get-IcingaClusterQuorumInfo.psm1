function Get-IcingaClusterQuorumInfo() 
{
    param (
        
    );
    
    if (-Not (Test-IcingaClusterInstalled)) {
        return @{ };   
    }

    $ClusterQuorums = Get-IcingaWindowsInformation -ClassName MSCluster_AvailableStoragePool -Namespace 'Root\MSCluster';
    $QuorumData     = @{ };

    foreach ($quorum in $ClusterQuorums) {
        $detail = @{
            'Caption' = $quorum.Caption;
            'InstallDate' = $quorum.InstallDate;
            'Status'      = $quorum.Status;
            'Flags'       = $quorum.Flags;
            'Characteristics' = $quorum.Characteristics;
            'Id'              = $quorum.Id;
            'Name'            = $quorum.Name;
            'Description'     = $quorum.Description;
            'HealthStatus'    = $quorum.HealthStatus;
            'QuorumStatus'    = $quorum.QuorumStatus;
            'Attributes'      = $quorum.Attributes;
            'TotalSize'       = $quorum.TotalSize;
            'Usage'           = $quorum.Usage;
            'ConnectedNodes'  = @{ 'Unknown' = 'Unknown'; };
        };

        if ($null -ne $quorum.ConnectedNodes) {
            $ConnectedNodes = @{ };

            foreach ($node in $quorum.ConnectedNodes) {
                Add-IcingaHashtableItem -Hashtable $ConnectedNodes -Key ([string]$node) -Value $node | Out-Null;

                $detail.ConnectedNodes = $ConnectedNodes;
            }
        }

        $QuorumData.Add($quorum.Name, $detail);
    }

    return $QuorumData;
}
