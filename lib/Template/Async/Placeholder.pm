package Template::Async::Placeholder;
use strict;
use warnings;

my $count = 1;

sub new {
    my ($class) = @_;
    my $self = bless { string => 'ASYNC-placeholder-' . $count++ }, $class;
    return $self;
}

sub defer {
    my ($self, $block, $alias) = @_;
    $self->{block} = $block;
    $self->{alias} = $alias;
    return $self->{string};
}

sub resume {
    my ($self, $context, $data) = @_;
    my $stash = $context->stash;
    my $error;
    my $output = '';

    $stash->set($self->{alias}, $data);
    eval $self->{block};

    my $document = $stash->get('output');
    my $index = index $$document, $self->{string};
    substr $$document, $index, length($self->{string}), $output;
}

1;
