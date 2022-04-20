# @summary auditd service management
#
# @api private
#
class auditd::service {
  assert_private()

  if $auditd::service_manage {
    service { $auditd::service_name:
      ensure     => $auditd::service_ensure,
      enable     => $auditd::service_enable,
      hasrestart => false,
    }
  }
}
