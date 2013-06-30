package Template::Async;
use strict;
use warnings;

use base qw/ Template /;

use Template::Async::Grammar;
use Template::Async::Directive;
use Template::Async::Placeholder;
use Template::Parser;

use AnyEvent;

our $VERSION = '0.01';

sub new {
    my ($class, $config) = @_;

    my $cv = { cv => undef };
    my $output = '';

    $config->{PARSER} = Template::Parser->new({
        FACTORY => 'Template::Async::Directive',
        GRAMMAR => Template::Async::Grammar->new,
    });
    $config->{VARIABLES} = {
        async_cv => $cv,
        output => \$output,
    };

    my $real_output = delete $config->{OUTPUT} || \*STDOUT;
    $config->{OUTPUT} = \$output;

    my $self = $class->SUPER::new($config);
    $self->{_async_cv} = $cv,
    $self->{_real_output} = $real_output;
    $self->{_output} = \$output;

    return $self;
}

sub process {
    my ($self, $template, $args, $output) = @_;

    ${$self->{_output}} = '';
    my $cv = $self->{_async_cv}->{cv} = AnyEvent->condvar;

    $cv->begin;
    my $ret = $self->SUPER::process($template, $args);
    $cv->end;
    $cv->recv;

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

__END__

=pod

=head1 NAME

Template::Async - asynchronous template block processing

=head1 SYNOPSIS

Given a template:

    [% USE rest = Async.REST('http://remote.server/REST') -%]

    [% ASYNC res = $rest.get('/resource') -%]
      [% res.name %]
    [% END -%]

Process as usual, but with Template::Async:

    use Template::Async;

    my $template = Template::Async->new($config);

    $template->process('main.tt')
      || die $template->error;

=head1 DESCRIPTION

Template Toolkit addon, providing deferred processing of "ASYNC"
blocks.

=head1 DEVELOPMENT

The source to Template::Async is in github:

  https://github.com/chrisa/perl-Template-Async

=head1 AUTHOR

Chris Andrews <chris@nodnol.org>

=head1 LICENCE AND COPYRIGHT

Copyright (C) 2013, Chris Andrews <chris@nodnol.org>.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
