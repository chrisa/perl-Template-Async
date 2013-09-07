package Template::Plugin::Async::Call;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use AnyEvent;

sub test {
    my ($self) = @_;
    my ($cv, $ph) = $self->async_call;

    my $guard; $guard = AnyEvent->timer(
        after => 1,
        cb => sub {
            $self->process_wait($guard);
            $ph->resume($self->context, 'test');
            $cv->end;
        }
    );
    
    return $ph;
}

1;
