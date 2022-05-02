# Icinga Powershell Cluster CHANGELOG
**The latest release announcements are available on [https://icinga.com/blog/](https://icinga.com/blog/).**

Please read the [upgrading](30-Upgrading-Plugins.md)
documentation before upgrading to a new release.

Released closed milestones can be found on [GitHub](https://github.com/Icinga/icinga-powershell-cluster/milestones?state=closed).

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
