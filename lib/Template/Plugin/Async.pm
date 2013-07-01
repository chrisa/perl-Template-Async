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
    my $cvs = $self->context->stash->get('async_cv');
    my $ph = Template::Async::Placeholder->new;
    $cvs->{completion}->begin;
    return ($cvs->{completion}, $ph);
}

sub process_wait {
    my ($self) = @_;
    my $cvs = $self->context->stash->get('async_cv');
    $cvs->{process}->recv;
}

sub context {
    my ($self) = @_;
    return $self->{context};
}

1;
