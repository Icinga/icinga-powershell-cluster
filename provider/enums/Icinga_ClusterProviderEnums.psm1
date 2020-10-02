<##################################################################################################
################# /lib/provider/culsterNodes ######################################################
##################################################################################################>

[hashtable]$ClusterNodeDedicated = @{
    0  = 'Not Dedicated';
    1  = 'Unknown';
    2  = 'Other';
    3  = 'Storage';
    4  = 'Router';
    5  = 'Switch';
    6  = 'Layer 3 Switch';
    7  = 'Central Office Switch';
    8  = 'Hub';
    9  = 'Access Server';
    10 = 'Firewall';
    11 = 'Print';
    12 = 'I/O';
    13 = 'Web Caching';
}

[hashtable]$ClusterNodeDedicatedName = @{
    'Not Dedicated'         = 0;
    'Unknown'               = 1;
    'Other'                 = 2;
    'Storage'               = 3;
    'Router'                = 4;
    'Switch'                = 5;
    'Layer 3 Switch'        = 6;
    'Central Office Switch' = 7;
    'Hub'                   = 8;
    'Access Server'         = 9;
    'Firewall'              = 10;
    'Print'                 = 11;
    'I/O'                   = 12;
    'Web Caching'           = 13;
}

[hashtable]$ClusterPowerManagementCapabilities = @{
    0 = 'Unknown';
    1 = 'Not Supported';
    2 = 'Disabled';
    3 = 'Enabled';
    4 = 'Power Saving Modes Entered Automatically';
    5 = 'Power State Settable';
    6 = 'Power Cycling Supported';
    7 = 'Timed Power On Supported';
}

[hashtable]$ClusterPowerManagementCapabilitiesName = @{
    'Unknown'                                  = 0;
    'Not Supported'                            = 1;
    'Disabled'                                 = 2;
    'Enabled'                                  = 3;
    'Power Saving Modes Entered Automatically' = 4;
    'Power State Settable'                     = 5;
    'Power Cycling Supported'                  = 6;
    'Timed Power On Supported'                 = 7;
}

[hashtable]$ClusterNodeState = @{
    -1 = 'Unknown';
    0  = 'Up';
    1  = 'Down';
    2  = 'Paused';
    3  = 'Joining';
}

[hashtable]$ClusterNodeStateName = @{
    'Unknown' = -1;
    'Up'      = 0;
    'Down'    = 1;
    'Paused'  = 2;
    'Joining' = 3;
}

[hashtable]$ClusterNodeDrainStatus = @{
    0 = 'Not Initiated';
    1 = 'In Progress';
    2 = 'Completed';
    3 = 'Failed';
}

[hashtable]$ClusterNodeDrainStatusName = @{
    'Not Initiated' = 0;
    'In Progress'   = 1;
    'Completed'     = 2;
    'Failed'        = 3;
}

[hashtable]$ClusterNodeStatusInfo = @{
    0 = 'Normal';
    1 = 'Isolated';
    2 = 'Quarantined';
}

[hashtable]$ClusterNodeStatusInfoName = @{
    'Normal'      = 0;
    'Isolated'    = 1;
    'Quarantined' = 2;
}

[hashtable]$ClusterProviderEnums = @{
    #/lib/provider/clusterNodes
    ClusterNodeState                       = $ClusterNodeState;
    ClusterNodeStateName                   = $ClusterNodeStateName;
    ClusterNodeDedicated                   = $ClusterNodeDedicated;
    ClusterNodeStatusInfo                  = $ClusterNodeStatusInfo;
    ClusterNodeStatusInfoName              = $ClusterNodeStatusInfoName;
    ClusterNodeDedicatedName               = $ClusterNodeDedicatedName;
    ClusterNodeDrainStatus                 = $ClusterNodeDrainStatus;
    ClusterNodeDrainStatusName             = $ClusterNodeDrainStatusName; 
    ClusterPowerManagementCapabilities     = $ClusterPowerManagementCapabilities;
    ClusterPowerManagementCapabilitiesName = $ClusterPowerManagementCapabilitiesName;
}

Export-ModuleMember -Variable @('ClusterProviderEnums');
