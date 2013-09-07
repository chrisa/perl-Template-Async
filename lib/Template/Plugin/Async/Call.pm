package Template::Plugin::Async::Call;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use AnyEvent;

sub test {
    my ($self) = @_;
    my $ph = $self->placeholder;

    my $guard; $guard = AnyEvent->timer(
        after => 1,
        cb => sub {
            $ph->resume($self->context, $guard, 'test');
        }
    );

    return $ph;
}

1;
