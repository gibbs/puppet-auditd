# @summary
#   Manages the auditd service
#
# @api private
#
class auditd::service {
  assert_private()

  service { $auditd::service_name:
    ensure     => $auditd::service_ensure,
    enable     => $auditd::service_enable,
    hasrestart => false,
  }
}
