# auditd plugin parameters
type Auditd::Plugins = Struct[
  {
    Optional['active']    => Enum['yes', 'no'],
    Optional['direction'] => Enum['in', 'out'],
    'path'                => Stdlib::Absolutepath,
    Optional['type']      => Enum['builtin', 'always'],
    Optional['args']      => String,
    Optional['format']    => Enum['binary', 'string'],
  }
]
