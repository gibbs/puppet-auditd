# auditd

[![Build Status](https://github.com/gibbs/puppet-auditd/workflows/CI/badge.svg)](https://github.com/gibbs/puppet-auditd/actions?query=workflow%3ACI)
[![Release](https://github.com/gibbs/puppet-auditd/workflows/Release/badge.svg)](https://github.com/gibbs/puppet-auditd/actions?query=workflow%3ARelease)
[![Apache-2 License](https://img.shields.io/github/license/gibbs/puppet-auditd.svg)](LICENSE)

## Overview

This module installs, configures and manages auditd. No default rules are
provided.

## Usage

### Default Behaviour

Including `auditd` and using the defaults will;

- Install the audit daemon package
- Configure and manage `/etc/audit/auditd.conf`
- Manage `/etc/audit/rules.d/audit.rules`
- Enable and manage the `auditd` service

```puppet
include auditd
```

### Config

The `auditd::config` parameter is used to configure the `auditd.conf` file:

- By default actions use `rotate/syslog` instead of `suspend/halt`
- Key names are based on documented settings in `man auditd.conf`

### Rules

The `auditd::rule` define is used to create and manage auditd rules.

```puppet
auditd::rule { 'insmod':
  content => '-w /sbin/insmod -p x -k modules',
  order   => 10,
}

auditd::rule { '-w /var/run/utmp -p wa -k session': }
```

A hash can also be passed to the main `auditd` with the `rules` parameter:

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
