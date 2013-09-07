package Template::Async::Placeholder;
use strict;
use warnings;

use Promises qw/ deferred /;

sub new {
    my ($class) = @_;
    my $d = deferred;
    my $self = bless { string => "ASYNC-placeholder-$d", deferred => $d }, $class;
    return $self;
}

sub defer {
    my ($self, $block, $alias) = @_;
    $self->{block} = $block;
    $self->{alias} = $alias;
    return $self->{string};
}

sub promise {
    my ($self) = @_;
    return $self->{deferred}->promise;
}

sub resume {
    my ($self, $context, $guard, $data) = @_;
    my $stash = $context->stash;
    my $error;
    my $output = '';

    $stash->set($self->{alias}, $data);
    eval $self->{block};

    my $document = $stash->get('output');
    my $index = index $$document, $self->{string};
    substr $$document, $index, length($self->{string}), $output;

    $self->{deferred}->resolve;
}

1;
