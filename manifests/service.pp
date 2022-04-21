# @summary auditd service management
#
# @api private
#
class auditd::service {
  assert_private()

  if $auditd::service_manage {
    if $auditd::service_override {
      file { '/etc/systemd/system/auditd.service.d':
        ensure => directory,
        owner  => 0,
        group  => 0,
        mode   => '0750',
      }

      file { '/etc/systemd/system/auditd.service.d/override.conf':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0640',
        content => $auditd::service_override,
      }
    }

    service { $auditd::service_name:
      ensure     => $auditd::service_ensure,
      enable     => $auditd::service_enable,
      hasrestart => false,
    }
  }
}
