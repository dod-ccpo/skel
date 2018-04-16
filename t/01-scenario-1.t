#!perl
#
use Test::More;
use Test::Mojo;

require 'ata';

my $t = Test::Mojo->new;
$t->ua->max_redirects(2);

# 1. Alice directs her office to move this workload to the cloud and asks
# Diane to finds funds (either in the existing budget ro through another
# office), and then gives written approval to Charlie to start the process
# (outside of AT-AT)

# 2. Charlie gets an LOA and a task number associated with the JEDI
# Cloud contract.  (outside of AT-AT)

# 3. Charlie logs into AT-AT and requests a new account, using the information
# from the task order and adds Alice and Bob as contacts and initial users
# with permissions to manage the account.

$t->get_ok('/login')->status_is(200)
  ->post_ok('/login' => form => { username => 'charlie', 'log in with CAC' => 1 })
  ->status_is(200)
  ->content_like( '/charlie/' );

$t->get_ok('/create_user')->status_is(200);


done_testing;
