# @summary auditd configuration
#
# @api private
#
class auditd::config {
  assert_private()

  $notify_service = $auditd::service_manage ? {
    true    => Service[$auditd::service_name],
    default => undef,
  }

  file { $auditd::dir:
    ensure => directory,
    owner  => $auditd::owner,
    group  => $auditd::group,
    mode   => $auditd::mode,
  }

  file { $auditd::plugin_dir:
    ensure => directory,
    owner  => $auditd::plugin_dir_owner,
    group  => $auditd::plugin_dir_group,
    mode   => $auditd::plugin_dir_mode,
  }

  file { $auditd::rules_dir:
    ensure => directory,
    owner  => $auditd::rules_dir_owner,
    group  => $auditd::rules_dir_group,
    mode   => $auditd::rules_dir_mode,
  }

  concat { $auditd::rules_file:
    order  => 'numeric',
    owner  => $auditd::rules_file_owner,
    group  => $auditd::rules_file_group,
    mode   => $auditd::rules_file_mode,
    notify => $notify_service,
  }

  concat::fragment { 'auditd_rules_begin':
    target  => $auditd::rules_file,
    order   => 0,
    content => epp('auditd/audit-rules-begin.fragment.epp', {
        buffer_size  => $auditd::buffer_size,
        failure_mode => $auditd::failure_mode,
    }),
  }

  concat::fragment { 'auditd_rules_end':
    target  => $auditd::rules_file,
    order   => 1000,
    content => epp('auditd/audit-rules-end.fragment.epp', {
        immutable => $auditd::immutable,
    }),
  }

  file { $auditd::config_path:
    ensure  => file,
    owner   => $auditd::config_owner,
    group   => $auditd::config_group,
    mode    => $auditd::config_mode,
    content => epp('auditd/auditd.conf.epp', {
        config => $auditd::config,
    }),
    notify  => $notify_service,
  }
}
