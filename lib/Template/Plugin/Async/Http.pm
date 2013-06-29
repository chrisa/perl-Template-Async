package Template::Plugin::Async::Http;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use AnyEvent::HTTP;
use JSON::XS;

my $json = JSON::XS->new->utf8->allow_blessed(1)->convert_blessed(1);

sub get {
    my ($self, $url) = @_;
    my ($cv, $ph) = $self->async_call;

    my $guard; $guard = http_get(
        $url,
        sub {
            my ($body, $head) = @_;
            my $data = $json->decode($body);
            $ph->resume($self->context, $data, $guard);
            $cv->end;
        }
    );

    return $ph;
}

1;
