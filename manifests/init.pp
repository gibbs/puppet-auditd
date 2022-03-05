# @summary
#   audit daemon
#
# @param package_name
#   The package name to manage
#
# @param package_ensure
#   The package state
#
# @param service_enable
#   The service enable state
#
# @param service_name
#   The service name to manage
#
# @param rules_dir
#   The rules directory path to use
#
# @param rules_file
#   The rules file to use
#
# @param config
#   audit daemon configuration hash
#
# @param syslog_output
#   Enable syslog output
#
# @author Dan Gibbs <dev@dangibbs.co.uk>
#
class auditd (
  String[1] $package_name                 = 'auditd',
  String $package_ensure                  = 'installed',
  Boolean $service_enable                 = true,
  String[1] $service_name                 = 'auditd',
  Stdlib::Ensure::Service $service_ensure = 'running',
  Stdlib::Absolutepath $rules_file        = '/etc/audit/rules.d/audit.rules',
  Auditd::Conf $config                    = {},
  Integer $buffer_size                    = 8192,
  Integer $failure_mode                   = 1,
  Boolean $immutable                      = false,
  Boolean $syslog_output                  = true,
) {

  contain auditd::package
  contain auditd::config
  contain auditd::service

  Class['auditd::package']
  -> Class['auditd::config']
  -> Class['auditd::service']
}
