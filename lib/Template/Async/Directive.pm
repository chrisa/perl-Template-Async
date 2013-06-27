package Template::Async::Directive;
use strict;
use warnings;

use base qw/ Template::Directive /;

sub async {

    print STDERR "in async directive\n";

    return <<EOF;

# ASYNC
$Template::Directive::OUTPUT do {
  'async';
};
EOF
};

1;
