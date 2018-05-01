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

# a) charlie logs in
$t->get_ok('/login')->status_is(200)
  ->post_ok('/login' => form => {username => 'charlie', 'log in with CAC' => 1})
  ->status_is(200)->content_like('/charlie/');

# b) charlie adds a task number

$t->get_ok('/create_bucket')->post_ok(
  '/create_bucket' => form => {
    bucket_type => 'task_order',
    task_number => 8011,
    name        => 'an interesting task'
  }
)->status_is(200);

# c) charlie adds alice, with permission to manage roles
# d) charlie adds bob, with permission to manage roles
for my $who (qw/alice bob/) {
  $t->get_ok('/create_user')->post_ok('/create_user' => form => {name => $who})
    ->status_is(200);
  $t->get_ok('/manage_roles')->content_like('/' . $who . '/');

  my %checked = $t->tx->res->dom->find('input')->map(
    sub {
      ($_->attr('name') => $_->val);
    }
  )->each;
  my %selected = $t->tx->res->dom->find('select')->map(
    sub {
      $_->attr('name') => $_->val;
    }
  )->each;

  $selected{$who . '_roles'} = ['bucket_creator'];
  my %params = (%checked, %selected);
  $t->post_ok('/manage_roles' => form => \%params)->status_is(200)
    ->content_like('/Saved/');
}

# Ensure Alice can manage roles.
$t->get_ok('/manage_roles');
is $t->tx->res->dom->at('select[name=alice_roles]')->val->[0],
  'bucket_creator', 'Alice is a bucket creator';

$t->get_ok('/logout')->status_is(200);

# Log in as Alice, ensure we can manage roles.
$t->get_ok('/login')->status_is(200)
  ->post_ok('/login' => form => {username => 'alice', 'log in with CAC' => 1});

# First, select the task order.
$t->get_ok('/select_bucket')->get_ok('/select_bucket?bucket=8011')
  ->get_ok('/manage_roles')->status_is(200);

done_testing;
