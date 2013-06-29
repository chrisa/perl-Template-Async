package Template::Async;
use strict;
use warnings;

use base qw/ Template /;

use Template::Async::Grammar;
use Template::Async::Directive;
use Template::Async::Placeholder;
use Template::Parser;

use AnyEvent;

sub new {
    my ($class, $config) = @_;

    my $cvs = [];
    my $output = '';

    $config->{PARSER} = Template::Parser->new({
        FACTORY => 'Template::Async::Directive',
        GRAMMAR => Template::Async::Grammar->new,
    });
    $config->{VARIABLES} = {
        async_cvs => $cvs,
        output => \$output,
    };

    my $real_output = delete $config->{OUTPUT} || \*STDOUT;
    $config->{OUTPUT} = \$output;

    my $self = $class->SUPER::new($config);
    $self->{_async_cvs} = $cvs;
    $self->{_real_output} = $real_output;
    $self->{_output} = \$output;

    return $self;
}

sub process {
    my ($self, $template, $args, $output) = @_;

    ${$self->{_output}} = '';
    my $ret = $self->SUPER::process($template, $args);

    while (my $cv = shift @{ $self->{_async_cvs} })  {
        $cv->recv;
    }

    my $outstream = $output || $self->{_real_output};
    unless (ref $outstream) {
        my $outpath = $self->{ OUTPUT_PATH };
        $outstream = "$outpath/$outstream" if $outpath;
    }

    my $error = &Template::_output($outstream, $self->{_output}, {});
    return ($self->error($error))
         if $error;
    return $ret;
}

1;
