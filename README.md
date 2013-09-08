Template::Async
===============

This is an extension to the Template Toolkit, adding a new directive
"ASYNC", which permits the declaration of blocks which are processed
only after some action has completed.

Example:

    [% USE rest = Async.REST('http://remote.server/REST') -%]

    [% ASYNC res = $rest.get('/resource') -%]
      [% res.name %]
    [% END -%]

Here, the ASYNC block is processed when the HTTP call to the remote
server returns, and makes use of the returned data.

Multiple ASYNC block actions may be outstanding concurrently, and
their blocks will be processed as the actions complete.

You'd process this template in much the same way as for a regular
Template Toolkit template:

    use Template::Async;

    my $template = Template::Async->new(...);

    $template->process('main.tt')
      || die $template->error;

Promises
--------

This library uses Promises, https://metacpan.org/module/Promises, as
well as AnyEvent.

Plugins
-------

Specific "Async" plugins are required, which implement non-blocking
operations.

Two plugins are provided:

 * Http
 * REST
 * Stash

Http and REST both implement async HTTP calls initiated by ASYNC
blocks in the template -- REST addtionally JSON-parses the response.

Stash recovers a promise from the stash, and invokes the ASYNC block
with the results when it resolves. You can use this to start async
operations before template processing starts, by passing the
associated promises into the stash.

Caveats
-------

Error handling is minimal. An exception in a plugin will annoy
AnyEvent and wedge things. This will be fixed.

Depending on what else is going on, this library may not play with in
a larger AnyEvent environment. For example, using this in an
application hosted on the Twiggy webserver will fail. This may or may
not be fixable.

Copyright and Licence
---------------------

Copyright (C) 2013, Chris Andrews <chris@nodnol.org>

except for the parser class Yapp source and skeleton, which are:

Copyright (C) 1996-2012 Andy Wardley. All Rights Reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.
