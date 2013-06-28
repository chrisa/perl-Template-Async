package Template::Plugin::Async::Http;
use strict;
use warnings;

use base qw/ Template::Plugin /;

use AnyEvent::HTTP;

sub new {
    my ($class, $context) = @_;
    return bless {}, $class;
};

sub get {
    my ($self, $url) = @_;
    return { 'name' => 'hardcoded' };
}

1;
