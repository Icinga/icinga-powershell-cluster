@{
    ModuleVersion     = '1.4.0'
    GUID              = 'e224db78-5f9a-43ea-a985-911da9da70c8'
    Author            = 'Yonas Habteab'
    CompanyName       = 'Icinga GmbH'
    Copyright         = '(c) 2020 Icinga GmbH | GPL v2.0'
    Description       = 'A collection of Cluster plugins for the Icinga Powershell Framework'
    PowerShellVersion = '4.0'
    RequiredModules   = @(
        @{ModuleName = 'icinga-powershell-framework'; ModuleVersion = '1.10.0' },
        @{ModuleName = 'icinga-powershell-plugins'; ModuleVersion = '1.10.0' }
    )
    NestedModules     = @(
        '.\compiled\icinga-powershell-cluster.ifw_compilation.psm1'
    )
    FunctionsToExport     = @(
        'Import-IcingaPowerShellComponentCluster',
        'Invoke-IcingaCheckClusterHealth',
        'Invoke-IcingaCheckClusterSharedVolume',
        'Invoke-IcingaCheckClusterNetwork',
        'Get-IcingaClusterSharedVolumeData'
    )
    CmdletsToExport     = @(
    )
    VariablesToExport     = @(
        'ClusterProviderEnums'
    )
    PrivateData       = @{
        PSData  = @{
            Tags         = @('icinga', 'icinga2', 'icingawindows', 'cluster', 'hyperv', 'clusterPlugins', 'windowsplugins', 'icingaforwindows')
            LicenseUri   = 'https://github.com/Icinga/icinga-powershell-cluster/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/Icinga/icinga-powershell-cluster'
            ReleaseNotes = 'https://github.com/Icinga/icinga-powershell-cluster/releases'
        };
        Version  = 'v1.4.0'
        Name     = 'Windows Cluster';
        Type     = 'plugins';
        Function = '';
        Endpoint = '';
    }
    HelpInfoURI       = 'https://github.com/Icinga/icinga-powershell-cluster'
}

