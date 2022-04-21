# audispd.conf configuration file parameters
type Auditd::Audisp::Conf = Struct[
  {
    Optional['q_depth']         => Integer,
    Optional['overflow_action'] => Enum['ignore', 'IGNORE', 'syslog', 'SYSLOG', 'suspend', 'SUSPEND', 'single', 'SINGLE', 'halt', 'HALT'],
    Optional['priority_boost']  => Integer[0],
    Optional['max_restarts']    => Integer[0],
    Optional['name_format']     => Enum['none', 'NONE', 'hostname', 'HOSTNAME', 'fqd', 'FQD', 'numeric', 'NUMERIC', 'user', 'USER'],
    Optional['name']            => String,
    Optional['plugin_dir']      => Stdlib::Absolutepath,
  }
]
