# auditd rule parameters
type Auditd::Rules = Struct[
  {
    Optional['content'] => String,
    Optional['order']   => Integer[1, 99],
  }
]
