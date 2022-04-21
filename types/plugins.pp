# auditd plugin parameters
type Auditd::Plugins = Struct[
  {
    Optional['active']      => Enum['yes', 'no'],
    Optional['direction']   => Enum['in', 'out'],
    'path'                  => Variant[Stdlib::Absolutepath, String],
    Optional['type']        => Enum['builtin', 'always'],
    Optional['args']        => String,
    Optional['format']      => Enum['binary', 'string'],
    Optional['plugin_type'] => Enum['auditd', 'audisp'],
    Optional['mode']        => Stdlib::Filemode,
    Optional['owner']       => Variant[String, Integer],
    Optional['group']       => Variant[String, Integer],
  }
]
