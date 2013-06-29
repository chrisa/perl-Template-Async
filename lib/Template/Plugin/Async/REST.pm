package Template::Plugin::Async::REST;
use strict;
use warnings;

use base qw/ Template::Plugin::Async::Http /;

use AnyEvent::HTTP;
use JSON::XS;

my $json = JSON::XS->new->utf8->allow_blessed(1)->convert_blessed(1);

sub new {
    my ($class, $context, $base_url) = @_;
    my $self = $class->SUPER::new($context);
    $self->{base_url} = $base_url;
    return $self;
}

sub get {
    my ($self, $resource) = @_;
    my $url = $self->{base_url} . $resource;
    return $self->SUPER::get($url);
}

1;
