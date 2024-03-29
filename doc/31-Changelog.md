# Icinga Powershell Cluster CHANGELOG
**The latest release announcements are available on [https://icinga.com/blog/](https://icinga.com/blog/).**

Please read the [upgrading](30-Upgrading-Plugins.md)
documentation before upgrading to a new release.

Released closed milestones can be found on [GitHub](https://github.com/Icinga/icinga-powershell-cluster/milestones?state=closed).

## 1.4.0 (tbd)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-cluster/milestone/6?closed=1)

### Enhancements

## 1.3.1 (tbd)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-cluster/milestone/7?closed=1)

### Bugfixes

* [#52](https://github.com/Icinga/icinga-powershell-cluster/pull/52) Fixes broken Icinga plain configuration

## 1.3.0 (2023-08-01)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-cluster/milestone/5?closed=1)

### Bugfixes

* [#50](https://github.com/Icinga/icinga-powershell-cluster/pull/50) Fixes unwanted dependency between cluster shared volumes and shared disks

### Enhancements

* [#51](https://github.com/Icinga/icinga-powershell-cluster/pull/51) Updates configuration for Icinga 2.14

## 1.2.0 (2022-08-30)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-cluster/milestone/4?closed=1)

### Bugfixes

* [#42](https://github.com/Icinga/icinga-powershell-cluster/pull/42) Fixes missing check of state info for Cluster Shared Volume plugin, if the state info is not `Direct`

### Enhancements

* [#43](https://github.com/Icinga/icinga-powershell-cluster/pull/43) Updates configuration and dependencies for Icinga for Windows v1.10.0
* [#44](https://github.com/Icinga/icinga-powershell-cluster/pull/44) Adds new performance data handling for Icinga for Windows v1.10.0

## 1.1.1 (2022-05-13)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-cluster/milestone/3?closed=1)

### Bugfixes

* [#40](https://github.com/Icinga/icinga-powershell-cluster/issues/40) Fixes `Get-IcingaClusterSharedVolumeData` which was not available as public function and caused Hyper-V plugins to fail, because they rely on this function inside a cluster

## 1.1.0 (2022-05-03)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-cluster/milestone/2?closed=1)

### Bugfixes

* [#36](https://github.com/Icinga/icinga-powershell-cluster/issues/36) Fixes `Invoke-IcingaCheckClusterSharedVolume` which does not support `%` unit for space

### Enhancements

* [#28](https://github.com/Icinga/icinga-powershell-cluster/issues/28) Adds partition style monitoring to `Invoke-IcingaCheckClusterSharedVolume` and reports critical, if the style is `RAW`
* [#39](https://github.com/Icinga/icinga-powershell-cluster/pull/39) Adds support for Icinga for Windows v1.9.0 module isolation

## 1.0.0 (2021-06-10)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-cluster/milestone/1?closed=1)

### New Plugins

This release adds the following new plugins:

* Invoke-IcingaCheckClusterHealth
* Invoke-IcingaCheckClusterNetwork
* Invoke-IcingaCheckClusterSharedVolume
