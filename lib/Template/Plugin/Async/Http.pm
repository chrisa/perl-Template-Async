package Template::Plugin::Async::Http;
use strict;
use warnings;

use base qw/ Template::Plugin /;

use AnyEvent::HTTP;
use JSON::XS;

sub new {
    my ($class, $context) = @_;
    return bless { stash => $context->stash }, $class;
};

my $json = JSON::XS->new->utf8->allow_blessed(1)->convert_blessed(1);

sub get {
    my ($self, $url) = @_;
    my $cv = AnyEvent->condvar;
    push @{ $self->{stash}->get('async_cvs') }, $cv;

    my $placeholder = Template::Async::Placeholder->new;

    my $g; $g = http_get(
        $url,
        sub {
            my ($body, $head) = @_;
            my $data = $json->decode($body);
            $placeholder->resume($self->{stash}, $data, $g);
            $cv->send;
        }
    );

    return $placeholder;
}

1;
