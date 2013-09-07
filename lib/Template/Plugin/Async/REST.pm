package Template::Plugin::Async::REST;
use strict;
use warnings;

use base qw/ Template::Plugin::Async::Http /;

use AnyEvent::HTTP;
use JSON::Any;
use Try::Tiny;

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

    my $ph = $self->placeholder;

    my $guard; $guard = http_get(
        $url,
        sub {
            my ($body, $head) = @_;
            my $data;

            if (defined $body) {
                try {
                    $data = $json->decode($body);
                }
                catch {
                    $data = { error => "error: $_" };
                };
            }
            else {
                $data = { error => "Status: $head->{Status}" };
            }

            $ph->resume($self->context, $guard, $data);
        }
    );

    return $ph;
}

1;
