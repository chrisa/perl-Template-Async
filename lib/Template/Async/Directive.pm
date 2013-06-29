package Template::Async::Directive;
use strict;
use warnings;

use base qw/ Template::Directive /;

sub async {
    my ($self, $lnameargs, $block) = @_;
    my ($name, $args, $alias) = @$lnameargs;
    $name = shift @$name;
    $alias ||= $name;
    $args = $self->args($args);
    $name .= ", $args" if $args;

    return <<EOF;

# ASYNC
my \$placeholder = \$stash->set($alias, $name);
my \$block = <<'        EOBLOCK';
$block
EOBLOCK

$Template::Directive::OUTPUT do {
   \$placeholder->defer(\$block, $alias);
};
EOF
}

1;
