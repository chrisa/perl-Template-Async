package Template::Plugin::Async::Http;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use AnyEvent::HTTP;

sub get {
    my ($self, $url) = @_;
    my $ph = $self->placeholder;

    my $guard; $guard = http_get(
        $url,
        sub {
            my ($body, $head) = @_;
            $ph->resume($self->context, $guard, $body);
        }
    );

    return $ph;
}

1;
