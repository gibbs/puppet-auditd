# @summary Create plugin files
#
# @api public
#
# @param active
#   Set the plugin active state.
#
# @param direction
#   Give a clue to the event dispatcher about which direction events flow.
#
# @param path
#   The absolute path to the plugin executable.
#
# @param type
#   Tells the dispatcher how the plugin wants to be run.
#
# @param args
#   Pass arguments to the child program.
#
# @param format
#   Binary or string dispatcher options.
#
# @param plugin_type
#   The plugin type
#
# @param mode
#   The file mode to apply
#
# @param owner
#   The file owner to set
#
# @param group
#   The file group to set
#
define auditd::plugin (
  Variant[Stdlib::Absolutepath, String] $path,
  Enum['yes', 'no'] $active             = 'yes',
  Enum['in', 'out'] $direction          = 'out',
  Enum['builtin', 'always'] $type       = 'always',
  Optional[String] $args                = undef,
  Enum['binary', 'string'] $format      = 'string',
  Enum['auditd', 'audisp'] $plugin_type = 'auditd',
  Stdlib::Filemode $mode                = '0600',
  Variant[String, Integer] $owner       = 0,
  Variant[String, Integer] $group       = 0,
) {
  $plugin_path = ($plugin_type == 'audisp') ? {
    true    => $auditd::audisp::plugin_dir,
    default => $auditd::plugin_dir,
  }

  file { "auditd-${plugin_type}-plugin-${name}.conf":
    ensure  => file,
    path    => "${plugin_path}/${name}.conf",
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    content => epp('auditd/plugin.conf.epp', {
      active    => $active,
      direction => $direction,
      path      => $path,
      type      => $type,
      args      => $args,
      format    => $format,
    }),
    notify  => Service['auditd'],
  }
}
