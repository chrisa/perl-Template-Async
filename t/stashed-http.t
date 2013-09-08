use strict;
use warnings;
use Test::More;

use AnyEvent;
use AnyEvent::HTTP;
use Promises qw/ deferred /;
use JSON::Any;

use Template::Async;
use Template::Constants qw( :debug );

#$Template::Parser::DEBUG = 1;
#$Template::Directive::PRETTY = 1;
my $DEBUG = undef; # DEBUG_ALL;

my $json = JSON::Any->new( utf8 => 1 );

sub fetch_it {
    my ($uri) = @_;
    my $d = deferred;
    http_get $uri => sub {
        my ($body, $headers) = @_;
        $headers->{Status} == 200
             ? $d->resolve( $json->decode( $body ) )
             : $d->reject( $body )
         };
    return $d->promise;
}

my $url = 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22MSFT%22)%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json';

subtest 'run process' => sub {

    # in controller...
    my $p = fetch_it($url);

    # in view...
    my $t = Template::Async->new({ DEBUG => $DEBUG });

    ok $t
         => 'got a Template::Async object';

    my $template = template();
    my $output;

    ok $t->process(\$template, { quote => $p }, \$output)
         => 'processed test template ok';

    diag $output;

    like $output, qr/MSFT: [0-9.]+/
         => 'got expected output';
};

done_testing();

sub template {
    return <<'EOT';
[% USE stash = Async.Stash -%]
[% ASYNC val = $stash.get('quote') -%]
[% val.query.results.quote.symbol %]: [% val.query.results.quote.Ask %]
[% END -%]
EOT
}
