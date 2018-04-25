use Test::More;
use Atat::Objects;

my $u = User->new(username => 'alice', name => 'Alice');
is $u->name,     'Alice', 'Set name';
is $u->username, 'alice', 'Set username';

my $b = Bucket->new;
$b->amount(200_000);
$b->used(10_000);
$b->administrators([$u]);

is $b->amount,    200_000, 'set amount';
is $b->used,      10_000,  'used';
is $b->remaining, 190_000, 'calculated remaining';
is $b->administrators->[0]->name, 'Alice', 'Set administrator';

my $child = Bucket->new(amount => 50_000);
$child->add_parent($b, 50_000);

isa_ok $child->parents->[0], 'Allocation', 'made an allocation';
is $child->parents->[0]->amount, 50_000, 'set child bucket';

done_testing;

