# @summary audit daemon
#
# @param buffer_size
#   The buffer size to use
#
# @param failure_mode
#   The failure mode (defaults to printing failure message)
#
# @param immutable
#   Set if the configuration should be immutable
#
# @param dir
#   The auditd configuration directory path (e.g. /etc/audit)
#
# @param mode
#   The auditd configuration directory mode
#
# @param owner
#   The auditd configuration directory owner
#
# @param group
#   The auditd configuration directory group
#
# @param config
#   auditd.conf configuration hash
#
# @param config_path
#   auditd.conf configuration filepath (e.g. /etc/audit/auditd.conf)
#
# @param config_mode
#   The configurtion file mode
#
# @param config_owner
#   The configurtion file mode owner
#
# @param config_group
#   The configurtion file mode group
#
# @param package_name
#   The package name to use
#
# @param package_ensure
#   The package state to set
#
# @param package_manage
#   If the auditd package should be managed
#
# @param service_enable
#   The service enable state
#
# @param service_name
#   The service name to use
#
# @param service_ensure
#   The service ensure state
#
# @param service_manage
#   If the auditd service should be managed
#
# @param service_override
#   auditd service override content
#
# @param plugin_dir
#   The plugin directory path to manage
#
# @param plugin_dir_mode
#   The plugin directory mode
#
# @param plugin_dir_owner
#   The plugin directory owner
#
# @param plugin_dir_group
#   The plugin directory group
#
# @param plugins
#   Hash of auditd plugin configuration files to create
#
# @param rules_dir
#   The rules directory path to manage
#
# @param rules_dir_mode
#   The rules directory mode
#
# @param rules_dir_owner
#   The rules directory owner
#
# @param rules_dir_group
#   The rules directory group
#
# @param rules_file
#   The rules filepath
#
# @param rules_file_mode
#   The rules file mode
#
# @param rules_file_owner
#   The rules file owner
#
# @param rules_file_group
#   The rules file group
#
# @param rules
#   Hash of auditd rules to set
#
# @author Dan Gibbs <dev@dangibbs.co.uk>
#
class auditd (
  Integer $buffer_size                             = 8192,
  Integer $failure_mode                            = 1,
  Boolean $immutable                               = false,
  Stdlib::Absolutepath $dir                        = '/etc/audit',
  Stdlib::Filemode $mode                           = '0750',
  Variant[String[1], Integer] $owner               = 0,
  Variant[String[1], Integer] $group               = 0,
  Auditd::Conf $config                             = {},
  Stdlib::Absolutepath $config_path                = '/etc/audit/auditd.conf',
  Stdlib::Filemode $config_mode                    = '0600',
  Variant[String[1], Integer] $config_owner        = 0,
  Variant[String[1], Integer] $config_group        = 0,
  String[1] $package_name                          = 'auditd',
  String $package_ensure                           = 'installed',
  Boolean $package_manage                          = true,
  Boolean $service_enable                          = true,
  String[1] $service_name                          = 'auditd',
  Stdlib::Ensure::Service $service_ensure          = 'running',
  Boolean $service_manage                          = true,
  Optional[String] $service_override               = undef,
  Stdlib::Absolutepath $plugin_dir                 = '/etc/audit/plugins.d',
  Stdlib::Filemode $plugin_dir_mode                = '0750',
  Variant[String[1], Integer] $plugin_dir_owner    = 0,
  Variant[String[1], Integer] $plugin_dir_group    = 0,
  Hash[String, Auditd::Plugins] $plugins           = {},
  Stdlib::Absolutepath $rules_dir                  = '/etc/audit/rules.d',
  Stdlib::Filemode $rules_dir_mode                 = '0750',
  Variant[String[1], Integer] $rules_dir_owner     = 0,
  Variant[String[1], Integer] $rules_dir_group     = 0,
  Stdlib::Absolutepath $rules_file                 = '/etc/audit/rules.d/audit.rules',
  Stdlib::Filemode $rules_file_mode                = '0600',
  Variant[String[1], Integer] $rules_file_owner    = 0,
  Variant[String[1], Integer] $rules_file_group    = 0,
  Hash[String, Auditd::Rules] $rules               = {},
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

  $plugins.each |$name, $parameters| {
    auditd::plugin { $name:
      * => $parameters,
    }
  }
}
