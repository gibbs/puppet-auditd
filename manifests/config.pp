# @summary auditd configuration
#
# @api private
#
class auditd::config {
  assert_private()

  concat { $auditd::rules_file:
    mode   => '0600',
    owner  => 0,
    group  => 0,
    notify => Service['auditd'],
  }

  concat::fragment { 'auditd_rules_begin':
    target  => $auditd::rules_file,
    content => epp('auditd/audit-rules-begin.fragment.epp', {
      buffer_size  => $auditd::buffer_size,
      failure_mode => $auditd::failure_mode,
    }),
    order   => '01',
  }

  concat::fragment { 'auditd_rules_end':
    target  => $auditd::rules_file,
    content => epp('auditd/audit-rules-end.fragment.epp', {
      immutable => $auditd::immutable,
    }),
    order   => '99',
  }

  file { '/etc/audit/auditd.conf':
    ensure  => file,
    mode    => '0600',
    owner   => 0,
    group   => 0,
    content => epp('auditd/auditd.conf.epp', {
      config => $auditd::config,
    }),
    notify  => Service['auditd'],
  }

  file { '/etc/audisp/plugins.d/syslog.conf':
    ensure  => file,
    content => epp('auditd/audisp_syslog_plugin.conf.epp', {
      syslog_output => $auditd::syslog_output,
    }),
    mode    => '0640',
    owner   => 0,
    group   => 0,
  }

  file { '/sbin/audispd':
    mode  => '0750',
    owner => 0,
    group => 0,
  }
}
