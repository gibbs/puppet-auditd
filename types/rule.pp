# auditd.conf configuration file parameters
type Auditd::Rule = Struct[
  {
    Optional['content'] => String,
    Optional['order']   => Integer[1, 100],
  }
]
