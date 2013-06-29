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
    my $cv = $self->context->stash->get('async_cv')->{cv};
    my $ph = Template::Async::Placeholder->new;
    $cv->begin;
    return ($cv, $ph);
}

sub context {
    my ($self) = @_;
    return $self->{context};
}

1;
