# @summary Creates auditd rules
#
# @api public
#
# @param content
#   The rule content
#
# @param order
#   The rule priority order (between 1 and 100)
#
define auditd::rule (
  String $content        = '',
  Integer[1, 100] $order = 10,
) {
  $rule_content = ($content == undef or $content == '') ? {
    true    => sprintf("%s\n\n", $name),
    default => sprintf("# %s\n%s\n\n", $name, $content),
  }

  concat::fragment { "auditd_fragment_${name}":
    target  => $auditd::rules_file,
    order   => $order,
    content => $rule_content,
  }
}
