package Template::Plugin::Async::Stash;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use Promises qw/ when /;

sub get {
    my ($self, $key) = @_;
    my $ph = $self->placeholder;
    my $p = $self->context->stash->get($key);

    when($p)->then(
        sub {
            my ($data) = @_;
            $ph->resume($self->context, undef, $data->[0]);
        }
    );

    return $ph;
}

1;
