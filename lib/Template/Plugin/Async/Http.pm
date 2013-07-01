package Template::Plugin::Async::Http;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use AnyEvent::HTTP;

sub get {
    my ($self, $url) = @_;
    my ($cv, $ph) = $self->async_call;

    my $guard; $guard = http_get(
        $url,
        sub {
            my ($body, $head) = @_;
            $self->process_wait($guard);
            $ph->resume($self->context, $body);
            $cv->end;
        }
    );

    return $ph;
}

1;
