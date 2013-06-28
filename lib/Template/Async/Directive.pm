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
\$stash->set($alias, $name);
do {

$block

};
EOF
}

1;
