use strict;
use warnings;
use Test::More;

use Template::Async;
use Template::Constants qw( :debug );

$Template::Parser::DEBUG = 1;
$Template::Directive::PRETTY = 1;

subtest 'run process' => sub {

    my $t = Template::Async->new({ DEBUG => DEBUG_ALL });

    ok $t
         => 'got a Template::Async object';

    my $template = template();
    my $output;

    ok $t->process(\$template, {}, \$output)
         => 'processed test template ok';

    is $output, "val: test\n"
         => 'got expected output';
    
};

done_testing();

sub template {
    return <<'EOT';
[% USE call = Async.Call -%]
[% ASYNC val = $call.test -%]
val: [% val %]
[% END -%]
EOT
}
