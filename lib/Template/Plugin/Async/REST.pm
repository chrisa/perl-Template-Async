package Template::Plugin::Async::REST;
use strict;
use warnings;

use base qw/ Template::Plugin::Async::Http /;

use AnyEvent::HTTP;
use JSON::Any;

my $json = JSON::Any->new( utf8 => 1 );

sub new {
    my ($class, $context, $base_url) = @_;
    my $self = $class->SUPER::new($context);
    $self->{base_url} = $base_url;
    return $self;
}

sub get {
    my ($self, $resource) = @_;
    my $url = $self->{base_url} . $resource;

    my ($cv, $ph) = $self->async_call;

    my $guard; $guard = http_get(
        $url,
        sub {
            my ($body, $head) = @_;
            my $data = $json->decode($body);
            $ph->resume($self->context, $data, $guard);
            $cv->end;
        }
    );

    return $ph;
}

1;
