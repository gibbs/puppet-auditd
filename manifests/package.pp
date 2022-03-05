# @summary
#   Manages the auditd package
#
# @api private
#
class auditd::package {
  assert_private()

  package { $auditd::package_name:
    ensure => $auditd::package_ensure,
  }
}
