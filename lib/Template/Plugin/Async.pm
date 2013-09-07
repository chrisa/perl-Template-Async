package Template::Plugin::Async;
use strict;
use warnings;

use base qw/ Template::Plugin /;

sub new {
    my ($class, $context) = @_;
    return bless { context => $context }, $class;
};

sub placeholder {
    my ($self) = @_;
    my $ph = Template::Async::Placeholder->new;
    $self->promise($ph->promise);
    return $ph;
}

sub promise {
    my ($self, $promise) = @_;
    my $promises = $self->context->stash->get('promises');
    push @{$promises}, $promise;
}

sub context {
    my ($self) = @_;
    return $self->{context};
}

1;
