package Template::Plugin::Async::Stash;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use Promises qw/ when /;

sub get {
    my ($self, $key) = @_;
    my $ph = $self->placeholder;
    my $p = $self->context->stash->get($key);

    if ($p->is_unfulfilled) {
        when($p)->then(
            sub {
                my ($data) = @_;
                $ph->resume($self->context, undef, $data->[0]);
            },
            sub {
                # error - returns empty data. might be better to not
                # run the block at all?
                $ph->resume($self->context, undef, {});
            }
        );
    }
    else {
        # too early to do this -- no use returning empty data, the
        # document isn't even there to replace our placeholder in yet
        # perhaps just abort this ASYNC block?
        $ph->resume($self->context, undef, {});
    }

    return $ph;
}

1;
