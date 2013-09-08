use strict;
use warnings;
use Test::More;

use AnyEvent;
use Promises;

use Template::Async;
use Template::Constants qw( :debug );

#$Template::Parser::DEBUG = 1;
#$Template::Directive::PRETTY = 1;
my $DEBUG = undef; # DEBUG_ALL;

subtest 'run process' => sub {

    my $d = Promises::Deferred->new;
    my $guard; $guard = AnyEvent->timer(
        after => 1,
        cb => sub {
            $d->resolve('test');
        }
    );

    my $t = Template::Async->new({ DEBUG => $DEBUG });

    ok $t
         => 'got a Template::Async object';

    my $template = template();
    my $output;

    ok $t->process(\$template, { test => $d->promise }, \$output)
         => 'processed test template ok';

    is $output, "val: test\n"
         => 'got expected output';

};

done_testing();

sub template {
    return <<'EOT';
[% USE stash = Async.Stash -%]
[% ASYNC val = $stash.get('test') -%]
val: [% val %]
[% END -%]
EOT
}
