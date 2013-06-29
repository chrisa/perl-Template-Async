package Template::Plugin::Async;
use strict;
use warnings;

use base qw/ Template::Plugin /;

use AnyEvent;

sub new {
    my ($class, $context) = @_;
    return bless { context => $context }, $class;
};

sub async_call {
    my ($self) = @_;
    my $ph = Template::Async::Placeholder->new;
    my $cv = AnyEvent->condvar;
    push @{ $self->context->stash->get('async_cvs') }, $cv;
    return ($cv, $ph);
}

sub context {
    my ($self) = @_;
    return $self->{context};
}

1;
