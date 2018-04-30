# Domain model.
#
# This file describes our domain using an object model.
#
# The following terminology may be helpful:
#     * 'package' defines a class.
#     * A class 'has' an attribute, which may be another object (delegation).
#     * Plural attributes imply a 1-many (or many-many) relationship.
#     * A class 'is' another class (vertical composition).
#     * A class 'does' a role (horizontal composition).

# User: An ATAT user.
package User {
  use Mojo::Base -base;
  has 'username';    # Username in ATAT
  has 'piv';         # Data from PIV card.
  has 'roles';       # Roles within ATAT.
}

# UserRole: Defines a set of permissions surrounding access to a CSP.
package UserRole {
  use Mojo::Base -base;
  has 'csp_account';    # CSP account (optional)
  has 'permissions';    # List of permissions (strings) for this role.
}

# Account: An account.
package Account {
  use Mojo::Base -base;
  has 'csp_role';       # The role in the CSP.
  has 'token';          # Auth token.
}

# Grant: A permission that a person has for a bucket.
package Grant {
  use Mojo::Base -base;
  has 'user';           # An ATAT user.
  has 'role';           # A UserRole (above).
}

# Bucket: An expense bucket.
package Bucket {
  use Mojo::Base -base, -signatures;
  use List::Util qw/sum/;
  has 'id';             # Unique identifier.
  has 'type' => 'bucket';    # String describing the type of bucket.
  has 'name';                # Name of the bucket.
  has 'limit';               # Limit on usage for this bucket.
  has 'used';                # Amount of money used.
  has 'grants';              # List of Grants for this bucket.
  has 'distribute_into'
    ;    # A list of other buckets into which this one can be distributed.
  has '_aggregated_into'
    ;    # A single parent bucket into which this one is aggregated.
  has '_aggregated_from'    # The inverse of the above.
    => sub { [] };
  has 'csp_tags';           # Tags in the CSP associated with this bucket.

  sub remaining ($self) {
    $self->limit - ($self->used || 0);
  }

  sub aggregate_to ($self, $bucket) {
    $self->_aggregated_into([$bucket]);
    push @{$bucket->_aggregated_from}, $self;
  }

  sub distribute_to ($self, $bucket, $amount) {
    push @{$self->distributed_into},
      Distribution->new(bucket => $bucket, amount => $amount);
  }

  sub calculate_used ($self, %args) {
    return $self->used if defined($self->used);
    my @children = @{$self->_aggregated_from || []};
    my $sum = sum map $_->calculate_used(%args), @children;
    $self->used($sum) if $args{store};
    return $sum;
  }
}

# A bucket can have an amount distributed to another bucket.
package Distribution {
  use Mojo::Base -base;
  has 'bucket';
  has 'amount';
}

# A TaskOrder is a bucket.
package TaskOrder {
  use Mojo::Base 'Bucket';
  has 'type' => 'task_order';
  has 'clins' => sub { [] };    # List of amount and clin
}

1;
