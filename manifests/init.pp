# @summary audit daemon
#
# @param package_name
#   The package name to use
#
# @param package_ensure
#   The package state to set
#
# @param service_enable
#   The service enable state
#
# @param service_name
#   The service name to use
#
# @param rules
#   Hash of auditd rules to set
#
# @param rules_file
#   The rules file to use
#
# @param config
#   auditd.conf configuration hash
#
# @param buffer_size
#   The buffer size to use
#
# @param failure_mode
#   The failure mode (defaults to printing failure message)
#
# @param immutable
#   Make the configuration immutable
#
# @param syslog_output
#   Enable syslog output
#
# @author Dan Gibbs <dev@dangibbs.co.uk>
#
class auditd (
  String[1] $package_name                      = 'auditd',
  String $package_ensure                       = 'installed',
  Boolean $service_enable                      = true,
  String[1] $service_name                      = 'auditd',
  Stdlib::Ensure::Service $service_ensure      = 'running',
  Stdlib::Absolutepath $rules_file             = '/etc/audit/rules.d/audit.rules',
  Optional[Hash[String, Auditd::Rules]] $rules = {},
  Auditd::Conf $config                         = {},
  Integer $buffer_size                         = 8192,
  Integer $failure_mode                        = 1,
  Boolean $immutable                           = false,
  Boolean $syslog_output                       = true,
) {

  contain auditd::package
  contain auditd::config
  contain auditd::service

  Class['auditd::package']
  -> Class['auditd::config']
  -> Class['auditd::service']

  $rules.each |$name, $parameters| {
    auditd::rule { $name:
      * => $parameters,
    }
  }
}
