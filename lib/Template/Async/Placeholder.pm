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
    $self->{alias} = $alias;
    $self->{block} = $block;
    return $self->{string};
}

sub resume {
    my ($self, $stash, $data) = @_;

    $stash->set($self->{alias}, $data);

    my $output = '';
    eval $self->{block};

    my $document = $stash->get('output');
    my $index = index $$document, $self->{string};
    substr $$document, $index, length($self->{string}), $output;
}

1;
