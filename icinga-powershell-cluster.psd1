@{
    ModuleVersion = '1.0'
    GUID = 'e224db78-5f9a-43ea-a985-911da9da70c8'
    Author            = 'Yonas Habteab'
    CompanyName       = 'Icinga GmbH'
    Copyright         = '(c) 2020 Icinga GmbH | GPL v2.0'
    Description       = 'A collection of Cluster plugins for the Icinga Powershell Framework'
    PowerShellVersion = '4.0'
    RequiredModules   = @(
        @{ModuleName = 'icinga-powershell-framework'; ModuleVersion = '1.2.0' },
        @{ModuleName = 'icinga-powershell-plugins'; ModuleVersion = '1.2.0' }
    )
    NestedModules     = @(
        '.\plugins\Invoke-IcingaCheckClusterNode.psm1'
        '.\provider\cluster\Get-IcingaClusterNodeInfo.psm1'
        '.\provider\enums\Icinga_ClusterProviderEnums.psm1'
    )
    FunctionsToExport = @('*')
    CmdletsToExport   = @('*')
    VariablesToExport = '*'
    AliasesToExport   = @()
    PrivateData       = @{

        PSData  = @{
            Tags         = @('icinga', 'icinga2', 'icingawindows', 'cluster', 'hyperv', 'clusterPlugins', 'windowsplugins', 'icingaforwindows')
            LicenseUri   = 'https://github.com/Icinga/icinga-powershell-cluster/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/Icinga/icinga-powershell-cluster'
            ReleaseNotes = 'https://github.com/Icinga/icinga-powershell-cluster/releases'

        };
        Version = 'v1.0.0'
    }
    HelpInfoURI       = 'https://github.com/Icinga/icinga-powershell-cluster'
}
