package Template::Plugin::Async;
use strict;
use warnings;

use base qw/ Template::Plugin /;

use AnyEvent;

sub new {
    my ($class, $context) = @_;
    return bless { context => $context }, $class;
};

sub push_cv {
    my ($self) = @_;
    my $cv = AnyEvent->condvar;
    push @{ $self->{context}->stash->get('async_cvs') }, $cv;
    return $cv;
}

1;
