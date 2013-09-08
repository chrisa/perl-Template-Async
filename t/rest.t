use strict;
use warnings;
use Test::More;

use Template::Async;
use Template::Constants qw( :debug );

#$Template::Parser::DEBUG = 1;
#$Template::Directive::PRETTY = 1;
my $DEBUG = undef; # DEBUG_ALL;

subtest 'run process' => sub {

    my $t = Template::Async->new({ DEBUG => $DEBUG });

    ok $t
         => 'got a Template::Async object';

    my $template = template();
    my $output;

    ok $t->process(\$template, {}, \$output)
         => 'processed test template ok';

    diag $output;

    like $output, qr/MSFT: [0-9.]+/
         => 'got expected output';

};

done_testing();

sub template {
    return <<'EOT';
[% USE rest = Async.REST('http://query.yahooapis.com/v1/public/yql?q=') -%]
[% ASYNC val = $rest.get('select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22MSFT%22)%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json') -%]
[% val.query.results.quote.symbol %]: [% val.query.results.quote.Ask %]
[% END -%]
EOT
}
