#!perl

use Test::More;
use Test::Mojo;

require 'ata';

my $t = Test::Mojo->new;

$t->get_ok('/')->status_is(200);

done_testing();
