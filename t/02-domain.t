use Test::More;
use Atat::Objects;

# Users and roles
my $alice = User->new(username => 'alice');
is $alice->username, 'alice', 'Set username';
$alice->piv({identifier => 101, serial_number => 23});
is $alice->piv->{identifier}, 101, 'set some PIV data';
my $bob = User->new(username => 'bob');
is $bob->username, 'bob', 'Made Bob';

# Make some roles:
my $engineer_101 = UserRole->new(
  name        => 'Engineer',
  csp_account => 101,
  permissions => [qw/access_cloud/]
);

my $engineer_100 = UserRole->new(
  name        => 'Engineer',
  csp_account => 100,
  permissions => [qw/access_cloud/]
);


my $administrator_100 = UserRole->new(
  name        => 'Administrator',
  permissions => [qw/create_bucket manage_roles create_user/],
  csp_account => 100,
);

# ATAT permissions for Alice and Bob
$alice->roles([$administrator_100, $engineer_101]);
$bob->roles([$engineer_100]);

is $alice->roles->[0]->csp_account, 100, 'Set csp account for Alice';
is $alice->roles->[1]->csp_account, 101, 'Set second csp account for Alice';
is $bob->roles->[0]->csp_account,   100, 'Set csp account for Bob';

# Buckets, distributions, and aggregations.
my $task_order = TaskOrder->new(
  limit => 200_000,
  id    => '9999-9999',
  name  => 'Sneakers and shoes',
  clins => [1234, 5678],
);

$task_order->grants([Grant->new(user => $alice, role => $administrator_100)]);

# Aggregate from team to mission to task order.
my $mission = Bucket->new(type => 'mission', name => "Capture the flag");
my $blue = Bucket->new(name => 'Blue team', type => 'team', id => 1);
$blue->aggregate_to($mission);
my $red = Bucket->new(name => 'Red team', type => 'team', id => 2);
$red->aggregate_to($mission);
$mission->aggregate_to($task_order);

# Set amount used by red and blue team, then aggregate up.
$red->used(10_000);
$blue->used(15_000);

# Run calculation, store mission and task order aggregates.
$task_order->calculate_used(store => 1);

# Check results.
is $mission->used,         25_000,  'Aggregated team into mission';
is $task_order->used,      25_000,  'Aggregated mission into task order';
is $task_order->remaining, 175_000, 'Calculated remaining';

done_testing;

