# @summary audit event dispatcher
#
# @param dir
#   The auditd configuration directory path
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
#   audispd.conf configuration hash
#
# @param config_path
#   audispd.conf file path
#
# @param config_mode
#   audispd.conf file mode
#
# @param config_owner
#   audispd.conf file owner
#
# @param config_group
#   audispd.conf file group
#
# @param package_name
#   The audisp plugins package name
#
# @param package_ensure
#   The package state to set
#
# @param package_manage
#   If the audisp plugin package should be managed
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
#    Hash of audisp plugin configuration files to create
#
# @author Dan Gibbs <dev@dangibbs.co.uk>
#
class auditd::audisp (
  Stdlib::Absolutepath $dir                        = '/etc/audisp',
  Stdlib::Filemode $mode                           = '0750',
  Variant[String[1], Integer] $owner               = 0,
  Variant[String[1], Integer] $group               = 0,
  Auditd::Audisp::Conf $config                     = {},
  Stdlib::Absolutepath $config_path                = '/etc/audisp/audispd.conf',
  Stdlib::Filemode $config_mode                    = '0600',
  Variant[String[1], Integer] $config_owner        = 0,
  Variant[String[1], Integer] $config_group        = 0,
  String[1] $package_name                          = 'audispd-plugins',
  String $package_ensure                           = 'installed',
  Boolean $package_manage                          = true,
  Stdlib::Absolutepath $plugin_dir                 = '/etc/audisp/plugins.d',
  Stdlib::Filemode $plugin_dir_mode                = '0750',
  Variant[String[1], Integer] $plugin_dir_owner    = 0,
  Variant[String[1], Integer] $plugin_dir_group    = 0,
  Optional[Hash[String, Auditd::Plugins]] $plugins = {},
) inherits auditd {

  if $package_manage {
    package { $package_name:
      ensure => $package_ensure,
    }
  }

  if $dir != $auditd::dir {
    file { $dir:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    }
  }

  if $plugin_dir != $auditd::plugin_dir {
    file { $plugin_dir:
      ensure => directory,
      owner  => $plugin_dir_owner,
      group  => $plugin_dir_group,
      mode   => $plugin_dir_mode,
    }
  }

  if $config_path != $auditd::config_path {
    file { $config_path:
      ensure  => file,
      owner   => $config_owner,
      group   => $config_group,
      mode    => $config_mode,
      content => epp('auditd/audisp.conf.epp', {
        config => $config,
      }),
    }
  }

  file { '/sbin/audispd':
    ensure => file,
    mode   => '0750',
  }

  $plugins.each |$name, $parameters| {
    auditd::plugin { $name:
      *           => $parameters,
      plugin_type => 'audisp',
    }
  }
}
