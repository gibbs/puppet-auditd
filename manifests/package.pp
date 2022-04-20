# @summary auditd package management
#
# @api private
#
class auditd::package {
  assert_private()

  if $auditd::package_manage {
    package { $auditd::package_name:
      ensure => $auditd::package_ensure,
    }
  }
}
