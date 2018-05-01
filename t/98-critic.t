use strict;
use warnings;
use File::Spec;
use Test::More;
use English qw(-no_match_vars);
use Test::Perl::Critic;

my $rcfile = File::Spec->catfile('t', 'perlcriticrc');
Test::Perl::Critic->import(-profile => $rcfile, -verbose => 10);
all_critic_ok('ata', 'lib');
