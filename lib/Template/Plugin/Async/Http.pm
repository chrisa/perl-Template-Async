package Template::Plugin::Async::Http;
use strict;
use warnings;

use base qw/ Template::Plugin::Async /;

use AnyEvent::HTTP;
use JSON::XS;

my $json = JSON::XS->new->utf8->allow_blessed(1)->convert_blessed(1);

sub get {
    my ($self, $url) = @_;
    my $cv = $self->push_cv;
    my $ph = Template::Async::Placeholder->new;

    my $g; $g = http_get(
        $url,
        sub {
            my ($body, $head) = @_;
            my $data = $json->decode($body);
            $ph->resume($self->{context}, $data, $g);
            $cv->send;
        }
    );

    return $ph;
}

1;
