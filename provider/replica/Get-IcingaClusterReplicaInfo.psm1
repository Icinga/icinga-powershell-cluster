function Get-IcignaClusterReplicaInfo()
{
    param (
        
    );
    
    if (-Not (Test-IcingaClusterInstalled)) {
        return @{ };
    }

    $GetInfos = Get-IcingaWindowsInformation -ClassName MSCluster_Node -NameSpace 'Root\MSCluster';
    $Data     = @{ };

    foreach ($node in $GetInfos) {
        $Measures = Measure-VMReplication -ComputerName $node.Name;
        $detail   = @{ };

        foreach ($replica in $Measures) {
            $detail.Add(
                $replica.Name, @{
                    'PrimaryServerName'            = $replica.PrimaryServerName;
                    'Name'                         = $replica.Name;
                    'ReplicationState'             = $replica.ReplicationState;
                    'CurrentReplicationServerName' = $replica.CurrentReplicationServerName;
                    'LastReplicationTime'          = $replica.LastReplicationTime;
                    'MissedReplicationCount'       = $replica.MissedReplicationCount;
                    'health'                       = $replica.health;
                }
            );
        }
         
        $Data.Add($node.Name, $detail);
    }

    return $Data;
}
