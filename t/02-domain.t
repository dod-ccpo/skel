use Test::More;
use Atat::Objects;

# Users and roles
my $alice = User->new(username => 'alice');
is $alice->username, 'alice', 'Set username';
$alice->piv({identifier => 101, serial_number => 23});
is $alice->piv->{identifier}, 101, 'set some PIV data';
my $bob = User->new(username => 'bob');
is $bob->username, 'bob', 'Made Bob';

# ATAT permissions for Alice and Bob
$alice->roles(
  [
    UserRole->new(
      csp_account => 100,
      permissions => [qw/create_bucket manage_roles create_user/]
    ),
    UserRole->new(csp_account => 101, permissions => [qw/access_cloud/]),
  ]
);
$bob->roles(
  [UserRole->new(csp_account => 100, permissions => [qw/access_cloud/])]);
is $alice->roles->[0]->csp_account, 100, 'Set csp account for Alice';
is $bob->roles->[0]->csp_account,   100, 'Set csp account for Bob';

# Buckets, distributions, and aggregations.
my $task_order = TaskOrder->new(limit => 200_000);

# Aggregate from team to mission to task order.
my $mission = Bucket->new( type => 'mission', name => "Capture the flag");
my $blue = Bucket->new( name => 'Blue team', type => 'team', id => 1);
$blue->aggregate_to($mission);
my $red = Bucket->new( name => 'Red team', type => 'team', id => 2);
$red->aggregate_to($mission);
$mission->aggregate_to($task_order);

# Set amount used by red and blue team, then aggregate up.
$red->used(10_000);
$blue->used(15_000);

# Run calculation, store mission and task order aggregates.
$task_order->calculate_used( store => 1);

# Check results.
is $mission->used, 25_000, 'Aggregated team into mission';
is $task_order->used, 25_000,'Aggregated mission into task order';
is $task_order->remaining, 175_000, 'Calculated remaining';

done_testing;

