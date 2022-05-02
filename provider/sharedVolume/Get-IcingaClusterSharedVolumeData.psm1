<#
.SYNOPSIS
    Fetch all information on the targeted Server regarding Cluster SharedVolumes and Cluster Resources.
    Returns a hashtable all required data for monitoring the health of Cluster SharedVolumes and some Cluster Resources.
.ROLE
    ### WMI Permissions

    * Root\MSCluster
    * Root\Cimv2

    ### Cluster Permissions

    * Full access on cluster ressources
.OUTPUTS
    System.Hashtable
.LINK
    https://github.com/Icinga/icinga-powershell-cluster
#>
function Get-IcingaClusterSharedVolumeData()
{
    param (
        [array]$IncludeVolumes = @(),
        [array]$ExcludeVolumes = @()
    );

    if (-Not (Test-IcingaClusterInstalled)) {
        Exit-IcingaThrowException -ExceptionType 'Custom' -CustomMessage 'Cluster not installed' -InputString 'The Cluster feature is not installed on this system.' -Force;
    }

    if (-Not (Test-IcingaFunction 'Get-ClusterSharedVolume')) {
        Exit-IcingaThrowException `
            -CustomMessage 'Cmdlet "Get-ClusterSharedVolume" not found' `
            -ExceptionType 'Custom' `
            -InputString ([string]::Format(
                'Either the "Get-ClusterSharedVolume" Cmdlet could not be found or you do not have any SharedVolumes configured on your system. {0}{1}',
                (New-IcingaNewLine),
                '"Get-ClusterSharedVolume" is only available on Windows Server 2012 and later.'
            ));
    }

    try {
        Get-ClusterSharedVolumeState -ErrorAction Stop | Out-Null;
    } catch {
        Exit-IcingaThrowException `
            -CustomMessage 'Cluster Shared Volume: Permission denied' `
            -ExceptionType 'Permission' `
            -ExceptionThrown 'The user running this plugin has no permmission to execute the Cmdlet "Get-ClusterSharedVolumeState"' `
            -InputString $_.CategoryInfo.Category -StringPattern 'AuthenticationError';

        Exit-IcingaThrowException `
            -InputString $_.Exception.Message `
            -ExceptionType 'Custom' `
            -Force;
    }

    $PartitionInformation    = $null;
    $DiskInformation         = $null;
    $GetClusterResource      = Get-IcingaClusterResource;
    $GetSharedVolume         = Get-ClusterSharedVolume;
    [bool]$AddPartitionStyle = $FALSE;

    if ((Test-IcingaFunction -Name 'Get-Partition') -And (Test-IcingaFunction -Name 'Get-Disk')) {
        $AddPartitionStyle    = $TRUE;
        $PartitionInformation = Get-Partition;
        $DiskInformation      = Get-Disk;
    }

    [double]$PercentFreeSpace = 0.0;
    [array]$SharedVolumes     = @();
    $ClusterDetails           = @{
        'Resources' = @{ };
    };

    if ($null -eq $GetClusterResource -or $null -eq $GetSharedVolume) {
        return @{ };
    }

    foreach ($volume in $GetSharedVolume) {
        $SharedVolumeState = Get-ClusterSharedVolume -Name $volume.Name | Get-ClusterSharedVolumeState;
        $details           = @{
            'OwnerNode'        = @{ };
            'SharedVolumeInfo' = @{
                'Partition' = @{
                    'MountPoints' = @{ };
                };
            };
        };

        if ($IncludeVolumes.Count -ne 0) {
            if ($IncludeVolumes.Contains($volume.Name) -eq $FALSE) {
                continue;
            }
        }

        if ($ExcludeVolumes.Count -ne 0) {
            if ($ExcludeVolumes.Contains($volume.Name) -eq $TRUE) {
                continue;
            }
        }

        $details.Add('Id', $volume.Caption);
        $details.Add('State', $volume.State);
        $details.Add('Name', $volume.Name);

        foreach ($node in $SharedVolumeState) {
            $details.OwnerNode.Add(
                $node.Node, @{
                    'Node'                         = $node.Node;
                    'Name'                         = $node.Name;
                    'BlockRedirectedIOReason'      = $node.BlockRedirectedIOReason;
                    'FileSystemRedirectedIOReason' = $node.FileSystemRedirectedIOReason;
                    'StateInfo'                    = $node.StateInfo;
                    'VolumeFriendlyName'           = $node.VolumeFriendlyName;
                    'VolumeName'                   = $node.VolumeName;
                }
            );
        }

        if ($volume.State -eq 'Online') {
            $VolumeInfo = $volume | Select-Object -Expand SharedVolumeInfo;

            foreach ($item in $VolumeInfo) {
                $PercentFreeSpace = [Math]::Round($item.Partition.PercentFree, 2);

                $details.SharedVolumeInfo.Add('FaultState', $item.FaultState);
                $details.SharedVolumeInfo.Add('FriendlyVolumeName', $item.FriendlyVolumeName);
                $details.SharedVolumeInfo.Add('MaintenanceMode', $item.MaintenanceMode);
                $details.SharedVolumeInfo.Add('PartitionNumber', $item.PartitionNumber);
                $details.SharedVolumeInfo.Add('RedirectedAccess', $item.RedirectedAccess);
                $details.SharedVolumeInfo.Add('VolumeOffset', $item.VolumeOffset);

                $details.SharedVolumeInfo.Partition.Add('DriveLetter', $item.Partition.DriveLetter);
                $details.SharedVolumeInfo.Partition.Add('DriveLetterMask', $item.Partition.DriveLetterMask);
                $details.SharedVolumeInfo.Partition.Add('FileSystem', $item.Partition.FileSystem);
                $details.SharedVolumeInfo.Partition.Add('FreeSpace', $item.Partition.FreeSpace);
                $details.SharedVolumeInfo.Partition.Add('HasDriveLetter', $item.Partition.HasDriveLetter);
                $details.SharedVolumeInfo.Partition.Add('IsCompressed', $item.Partition.IsCompressed);
                $details.SharedVolumeInfo.Partition.Add('IsDirty', $item.Partition.IsDirty);
                $details.SharedVolumeInfo.Partition.Add('IsFormatted', $item.Partition.IsFormatted);
                $details.SharedVolumeInfo.Partition.Add('IsNtfs', $item.Partition.IsNtfs);
                $details.SharedVolumeInfo.Partition.Add('IsPartitionNumberValid', $item.Partition.IsPartitionNumberValid);
                $details.SharedVolumeInfo.Partition.Add('Name', $item.Partition.Name);
                $details.SharedVolumeInfo.Partition.Add('PartitionNumber', $item.Partition.PartitionNumber);
                $details.SharedVolumeInfo.Partition.Add('PercentFree', $PercentFreeSpace);
                $details.SharedVolumeInfo.Partition.Add('Size', $item.Partition.Size);
                $details.SharedVolumeInfo.Partition.Add('UsedSpace', $item.Partition.UsedSpace);

                $details.SharedVolumeInfo.Partition.MountPoints = $item.Partition.MountPoints;
                $PercentFreeSpace = 0.0;
                [bool]$FoundStyle = $FALSE;

                if ($AddPartitionStyle) {
                    foreach ($partitionInfo in $PartitionInformation) {
                        if ($partitionInfo.AccessPaths -Contains $item.Partition.Name) {
                            foreach ($diskInfo in $DiskInformation) {
                                if ($diskInfo.Path -eq $partitionInfo.DiskId) {
                                    $details.SharedVolumeInfo.Partition.Add('PartitionStyle', $diskInfo.PartitionStyle);
                                    $FoundStyle = $TRUE;
                                    break;
                                }
                            }
                        }
                        if ($FoundStyle) {
                            break;
                        }
                    }
                }

                if ($AddPartitionStyle -eq $FALSE -Or $FoundStyle -eq $FALSE) {
                    $details.SharedVolumeInfo.Partition.Add('PartitionStyle', 'Unknown');
                }
            }
        } else {
            $details.SharedVolumeInfo.Add('Unknown', 'Unknown');
        }

        foreach ($resource in $GetClusterResource.Keys) {
            $ClusterResource = $GetClusterResource[$resource];
            if (($ClusterResource.Type -ne 'Physical Disk' -and $ClusterResource.Type -ne 'Storage QoS Policy Manager') -or ($SharedVolumes.Contains($resource) -eq $TRUE)) {
                continue;
            }

            $SharedVolumes += $resource;
            $ClusterDetails.Resources.Add($resource, $ClusterResource);
        }

        $ClusterDetails.Add($volume.Name, $details);
    }

    return $ClusterDetails;
}
