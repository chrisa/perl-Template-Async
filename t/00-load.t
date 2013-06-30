use strict;
use warnings;
use Test::More;

eval "use Template::Async; 1;" or BAIL_OUT $@;

ok(1, 'all modules loaded');

done_testing();
