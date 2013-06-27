package Template::Async;
use strict;
use warnings;

use base qw/ Template /;

use Template::Async::Grammar;
use Template::Async::Directive;
use Template::Parser;

sub new {
    my ($class, $config) = @_;
    $config->{PARSER} = Template::Parser->new({
        FACTORY => 'Template::Async::Directive',
        GRAMMAR => Template::Async::Grammar->new,
    });
    my $self = $class->SUPER::new($config);
    bless $self, $class;
    return $self;
}

1;
