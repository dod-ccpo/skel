#!perl

use Test::More;
use Atat::Objects;
use v5.20;

my $bob = User->new(username => 'bob');
my $team = Bucket->new(name => 'team a');
my $engineer =
  UserRole->new(name => 'engineer', permissions => {access_cloud => 1});
$team->add_grant($bob, $engineer);

ok $team->user_can($bob, 'access_cloud'), 'Bob has permission on a bucket';
ok !$team->user_can($bob, 'run_reports'),
  'Bob does not have permission on a bucket';
is $bob->bucket_roles($team)->[0]->name, $engineer->name, 'bucket roles works';

done_testing;

