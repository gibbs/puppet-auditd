# auditd

[![Build Status](https://github.com/gibbs/puppet-auditd/workflows/CI/badge.svg)](https://github.com/gibbs/puppet-auditd/actions?query=workflow%3ACI)
[![Release](https://github.com/gibbs/puppet-auditd/workflows/Release/badge.svg)](https://github.com/gibbs/puppet-auditd/actions?query=workflow%3ARelease)
[![Puppet Forge](https://img.shields.io/puppetforge/v/genv/auditd.svg?maxAge=2592000?style=plastic)](https://forge.puppet.com/genv/auditd)
[![Apache-2 License](https://img.shields.io/github/license/gibbs/puppet-auditd.svg)](LICENSE)

## Overview

This module installs, configures and manages the Linux Audit daemon (auditd)
and optionally the dispatcher (audisp) for older auditd versions.

No default rules are provided. See the Reference file for all options.

- [Usage](#usage)
- [Configuration](#configuration)
- [Rules](#rules)
- [Plugins](#plugins)
- [Dispatcher](#dispatcher)
- [Limitations](#limitations)

## Usage

Including `auditd` and using the defaults will;

- Install the audit daemon package
- Configure and manage `/etc/audit/auditd.conf` with most default settings
- Replace all `suspend/halt` settings with `rotate/syslog` to prevent unexpected
availability issues
- Manage `/etc/audit/rules.d/audit.rules`
- Enable and manage the `auditd` service

```puppet
include auditd
```

## Configuration

The `auditd::config` parameter is used to configure the `auditd.conf` file:

- By default actions use `rotate/syslog` instead of `suspend/halt`
- Key names are based on documented settings in `man auditd.conf`

## Rules

The `auditd::rule` define is used to create and manage auditd rules.

```puppet
auditd::rule { 'insmod':
  content => '-w /sbin/insmod -p x -k modules',
  order   => 10,
}

auditd::rule { '-w /var/run/utmp -p wa -k session': }
```

A hash can also be passed to the main `auditd` class with the `rules` parameter:

```puppet
class { 'auditd':
  rules => {
    insmod => {
      content => '-w /sbin/insmod -p x -k modules',
      order   => 10,
    },
    sudoers_changes => {
      content => '-w /etc/sudoers -p wa -k scope',
      order   => 50,
    },
  },
}
```

With Hiera:

```yaml
auditd::rules:
  insmod:
    content: -w /sbin/insmod -p x -k modules
    order: 10
  sudoers_changes:
    content: -w /etc/sudoers -p wa -k scope
    order: 50
```

## Plugins

The `auditd::plugin` define is used to create and manage auditd plugin files.

```puppet
auditd::plugin { 'clickhouse':
  active    => 'yes',
  direction => 'out',
  path      => '/usr/libexec/auditd-plugin-clickhouse',
  type      => 'always',
  args      => '/etc/audit/auditd-clickhouse.conf',
  format    => 'string',
}
```

A hash can also be passed to the main `auditd` with the `plugins` parameter:

```puppet
class { 'auditd':
  plugins => {
    auoms => {
      active    => 'no',
      direction => 'out',
      path      => '/opt/microsoft/auoms/bin/auomscollect',
    },
  },
}
```

With Hiera:

```yaml
auditd::plugins:
  clickhouse:
    active: 'yes'
    direction: 'out'
    path: /usr/libexec/auditd-plugin-clickhouse
    args: /etc/audit/auditd-clickhouse.conf
```

## Dispatcher

The `auditd::audisp` class can be used to manage the dispatcher *for version 2*.
Using this class on more recent auditd versions (v3) is not necessary and is
equivalent to:

```puppet
package { 'audispd-plugins':
  ensure => 'installed',
}
```

In v3 `audisp` settings can be part of `auditd::config`. For v2 use
`auditd::audisp`:

```puppet
class { 'auditd::audisp':
  config => {
    q_depth     => 250,
    name_format => 'hostname',
  },
}
```

```yaml
auditd::audisp::config:
  q_depth: 250
  overflow_action: syslog
  priority_boost: 4
  max_restarts: 10
  name_format: hostname
  plugin_dir: /etc/audisp/plugins.d/
```

### audisp plugins

The `auditd::plugin` define can be used to be manage audisp plugins by setting
`plugin_type` to `audisp`:

```puppet
auditd::plugin { 'syslog':
  active      => 'yes',
  direction   => 'out',
  path        => '/sbin/audisp-syslog',
  type        => 'always',
  args        => 'LOG_INFO',
  format      => 'string',
  plugin_type => 'audisp',
}
```

## Limitations

The `RefuseManualStop` systemd unit option has been set to `no` to allow for
easier upgrades and management. See [auditd.service and RefuseManualStop](https://lists.freedesktop.org/archives/systemd-devel/2014-April/018608.html)
for a discussion on this subject.

Configuration files distributed via `audispd-plugins` are not currently managed.

This package has been tested primarily on Debian family distributions.
