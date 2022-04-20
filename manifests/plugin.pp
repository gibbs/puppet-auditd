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
define auditd::plugin (
  Enum['yes', 'no'] $active = 'yes',
  Enum['in', 'out'] $direction = 'out',
  Stdlib::Absolutepath $path,
  Enum['builtin', 'always'] $type = 'always',
  Optional[String] $args = undef,
  Enum['binary', 'string'] $format = 'string',
  Stdlib::Filemode $mode = '0600',
  Variant[String, Integer] $owner = 0,
  Variant[String, Integer] $group = 0,
) {

  file { "auditd-plugin-${name}.conf":
    ensure  => file,
    path    => "${auditd::plugin_dir}/${name}.conf",
    mode    => $mode,
    owner   => $auditd::plugin_dir_owner,
    group   => $auditd::plugin_dir_group,
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
