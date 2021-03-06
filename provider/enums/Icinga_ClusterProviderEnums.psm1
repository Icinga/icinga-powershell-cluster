<#########################################################################################################
############################### lib/provider/clusterNetwork ##############################################
#########################################################################################################>

[hashtable]$ClusterNetState = @{
    -1 = 'Unknown';
    0  = 'Unavailable';
    1  = 'Down';
    2  = 'Partitioned';
    3  = 'Up';
}

[hashtable]$ClusterNetStateName = @{
    'Unknown'     = -1;
    'Unavailable' = 0;
    'Down'        = 1;
    'Partitioned' = 2;
    'Up'          = 3;
}

[hashtable]$ClusterNetRole = @{
    0 = 'None';
    1 = 'Cluster';
    2 = 'Client';
    3 = 'Both';
}

[hashtable]$ClusterNetRoleName = @{
    'None'    = 0;
    'Cluster' = 1;
    'Client'  = 2;
    'Both'    = 3;
}

[hashtable]$ClusterInterfaceAvailability = @{
    1  = 'Other';
    2  = 'Unknown';
    3  = 'Running/Full Power';
    4  = 'Warning';
    5  = 'In Test';
    6  = 'Not Applicable';
    7  = 'Power Off';
    8  = 'Off Line';
    9  = 'Off Duty';
    10 = 'Degraded';
    11 = 'Not Installed';
    12 = 'Install Error';
    13 = 'Power Save - Unknown';
    14 = 'Power Save - Low Power Mode';
    15 = 'Power Save - Standby';
    16 = 'Power Cycle';
    17 = 'Power Save - Warning';
    18 = 'Paused';
    19 = 'Not Ready';
    20 = 'Not Configured';
    21 = 'Quiesced';
}

[hashtable]$ClusterInterfaceAvailabilityName = @{
    'Other'                       = 1;
    'Unknown'                     = 2;
    'Running/Full Power'          = 3;
    'Warning'                     = 4;
    'In Test'                     = 5;
    'Not Applicable'              = 6;
    'Power Off'                   = 7;
    'Off Line'                    = 8;
    'Off Duty'                    = 9;
    'Degraded'                    = 10;
    'Not Installed'               = 11;
    'Install Error'               = 12;
    'Power Save - Unknown'        = 13;
    'Power Save - Low Power Mode' = 14;
    'Power Save - Standby'        = 15;
    'Power Cycle'                 = 16;
    'Power Save - Warning'        = 17;
    'Paused'                      = 18;
    'Not Ready'                   = 19;
    'Not Configured'              = 20;
    'Quiesced'                   = 21;
}

[hashtable]$ClusterInterfaceAvailabilityDebug = @{
    1  = 'The network interface availability is in another state';
    2  = 'The network interface availability is Unknown';
    3  = 'The network interface is available at full power';
    4  = 'The network interface is in a warning state';
    5  = 'The network interface is in a test state';
    6  = 'The network interface availability is not applicable';
    7  = 'The network interface is powered off';
    8  = 'The network interface is offline';
    9  = 'The network interface is off duty';
    10 = 'The network interface availability is degraded';
    11 = 'The network interface is not installed';
    12 = 'The network interface is not installed properly';
    13 = 'The network interface availability is known to be in a power save mode, but its exact status unknown';
    14 = 'The network interface is in a power save state but still functioning, and may exhibit degraded performance';
    15 = 'The network interface is not functioning but could be brought to full power quickly';
    16 = 'The network interface is being power cycled';
    17 = 'The network interface is in a warning state but also in a power save mode';
    18 = 'The network interface is paused';
    19 = 'The network interface is not ready';
    20 = 'The network interface is not configured';
    21 = 'The network interface is not quiesced';
}

[hashtable]$ClusterInterConfigManagerErrorCode = @{
    0  = 'The network interface is working properly';
    1  = 'The network interface is not configured correctly';
    2  = 'Windows cannot load the driver for the network interface';
    3  = 'The driver for the network interface might be corrupted, or the system may be low on memory or other resources';
    4  = 'The network interface is not working properly. One of its drivers or the registry might be corrupted';
    5  = 'The driver for the network interface requires a resource that Windows cannot manage';
    6  = 'Boot configuration for the network interface conflicts with other devices';
    7  = 'Cannot filter';
    8  = 'The driver loader for the network interface is missing';
    9  = 'The network interface is not working properly, the controlling firmware is incorrectly reporting the resources for the device';
    10 = 'The network interface cannot start';
    11 = 'The network interface failed';
    12 = 'The network interface cannot find enough free resources to use';
    13 = 'Windows cannot verify the network interfaces resources';
    14 = 'The network interface cannot work properly until the computer is restarted';
    15 = 'The network interface is not working properly due to a possible re-enumeration problem';
    16 = 'Windows cannot identify all of the resources that the network interface uses';
    17 = 'The network interface is requesting an unknown resource type';
    18 = 'The network interface device drivers must be reinstalled';
    19 = 'Failure using the VxD loader';
    20 = 'The registry might be corrupted';
    21 = 'System failure. If changing the device driver is ineffective, see the hardware documentation. Windows is removing the network interface';
    22 = 'The network interface is disabled';
    23 = 'System failure. If changing the network interface device driver is ineffective, see the hardware documentation';
    24 = 'The network interface is not present, not working properly, or does not have all aof its drivers installed';
    25 = 'Windows is still setting up the network interface';
    26 = 'Windows is still setting up the network interface';
    27 = 'The network interface does not have valid log configuration';
    28 = 'The network interface device drivers are not installed';
    29 = 'The network interface is disabled; the device firmware did not provide the required resources';
    30 = 'The network interface is using an IRQ resource that another device is using';
    31 = 'The network interface is not working properly; Windows cannot load the required device drivers';
}

[hashtable]$InterfacePowerManagementCapabilities = @{
    0 = 'Unknown';
    1 = 'Not Supported';
    2 = 'Disabled';
    3 = 'Enabled';
    4 = 'Power Saving Modes Entered Automatically';
    6 = 'Power State Settable';
    7 = 'Time Power On Supported';
}

[hashtable]$InterfacePowerManagementCapabilitiesName = @{
    'Unknown'                                  = 0;
    'Not Supported'                            = 1;
    'Disabled'                                 = 2;
    'Enabled'                                  = 3
    'Power Saving Modes Entered Automatically' = 4;
    'Power State Settable'                     = 5;
    'Time Power On Supported'                  = 7;
}

[hashtable]$InterfaceStatusInfo = @{
    0 = 'Other';
    1 = 'Unknown';
    2 = 'Enabled';
    3 = 'Disabled';
    4 = 'Not Applicable';
}

[hashtable]$InterfaceStatusInfoName = @{
    'Other'          = 0;
    'Unknown'        = 1;
    'Enabled'        = 2;
    'Disabled'       = 3;
    'Not Applicable' = 4;
}

<##################################################################################################
################# /lib/provider/networkVolumes ####################################################
##################################################################################################>

[hashtable]$RequiredDependencyClassesName = @{
    0     = 'Unknown';
    1     = 'Storage';
    2     = 'Network';
    32768 = 'User';
}

[hashtable]$RequiredDependencyClasses = @{
    'Unknown' = 0;
    'Storage' = 1;
    'Network' = 2;
    'User'    = 32768;
}

[hashtable]$ClusterServiceStateName = @{
    -1  = 'Unknown';
    0   = 'Inherited';
    1   = 'Initializing';
    2   = 'Online';
    3   = 'Offline';
    4   = 'Failed';
    126 = 'ClusterResourceCannotComeOnlineOnAnyNode';
    128 = 'Pending';
    130 = 'Online Pending';
}

[hashtable]$ClusterServiceState = @{
    'Unknown'                                  = -1;
    'Inherited'                                = 0;
    'Initializing'                             = 1;
    'Online'                                   = 2;
    'Offline'                                  = 3;
    'Failed'                                   = 4;
    'ClusterResourceCannotComeOnlineOnAnyNode' = 126;
    'Pending'                                  = 128;
    'Online Pending'                           = 130;
}

<###############################################################################################################
############################# /lib/provider/cluster ############################################################
###############################################################################################################>

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

<######################################################################################################
################################### /lib/cluster/Testing/Classes ######################################
######################################################################################################>

[hashtable]$ClusterExceptionState= @{
    'RestartingOrStopped' = '0x80070046';
    'ServiceStopped'      = '0x800706d9';
}

[hashtable]$ClusterExceptionIds= @{
    '0x80070046' = 'RestartingOrStopped';
    '0x800706d9' = 'ServiceStopped';
}

[hashtable]$ClusterExceptionMessages = @{
    '0x80070046' = 'The Cluster Service is Stopped or is being restarted';
    '0x800706d9' = 'The Cluster Service is Stopped or your cluster is not running properly';
}

[hashtable]$ClusterProviderEnums = @{
    # /lib/provider/clusterNet
    ClusterNetRole                           = $ClusterNetRole;
    ClusterNetRoleName                       = $ClusterNetRoleName;
    ClusterNetState                          = $ClusterNetState;
    ClusterNetStateName                      = $ClusterNetStateName;
    InterfaceStatusInfo                      = $InterfaceStatusInfo;
    InterfaceStatusInfoName                  = $InterfaceStatusInfoName;
    ClusterInterfaceAvailability             = $ClusterInterfaceAvailability;
    ClusterInterfaceAvailabilityName         = $ClusterInterfaceAvailabilityName;
    ClusterInterConfigManagerErrorCode       = $ClusterInterConfigManagerErrorCode;
    InterfacePowerManagementCapabilities     = $InterfacePowerManagementCapabilities;
    InterfacePowerManagementCapabilitiesName = $InterfacePowerManagementCapabilitiesName;
    ClusterInterfaceAvailabilityDebug        = $ClusterInterfaceAvailabilityDebug;
    #/lib/provider/networkVolumes
    RequiredDependencyClasses                = $RequiredDependencyClasses;
    RequiredDependencyClassesName            = $RequiredDependencyClassesName;
    ClusterServiceState                      = $ClusterServiceState;
    ClusterServiceStateName                  = $ClusterServiceStateName;
    #/lib/provider/cluster
    ClusterNodeState                         = $ClusterNodeState;
    ClusterNodeStateName                     = $ClusterNodeStateName;
    ClusterNodeDedicated                     = $ClusterNodeDedicated;
    ClusterNodeStatusInfo                    = $ClusterNodeStatusInfo;
    ClusterNodeStatusInfoName                = $ClusterNodeStatusInfoName;
    ClusterNodeDedicatedName                 = $ClusterNodeDedicatedName;
    ClusterNodeDrainStatus                   = $ClusterNodeDrainStatus;
    ClusterNodeDrainStatusName               = $ClusterNodeDrainStatusName;
    ClusterPowerManagementCapabilities       = $ClusterPowerManagementCapabilities;
    ClusterPowerManagementCapabilitiesName   = $ClusterPowerManagementCapabilitiesName;
    # /lib/cluster/Testing/Classes
    ClusterExceptionState                    = $ClusterExceptionState;
    ClusterExceptionIds                      = $ClusterExceptionIds;
    ClusterExceptionMessages                 = $ClusterExceptionMessages;
}

Export-ModuleMember -Variable @('ClusterProviderEnums');
