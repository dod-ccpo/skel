package User {
  use Mojo::Base -base;
  has 'username';
  has 'name';
}

package Bucket {
  use Mojo::Base -base, -signatures;
  has 'type';
  has 'name';
  has 'identifier';
  has 'amount';
  has 'used';
  has 'administrators';

  has 'parents' => sub { [] };

  # [ { bucket => $x, amount => $y} , ... ]

  sub remaining($self) {
    $self->amount - $self->used;
  }

  sub add_parent ($self, $bucket, $amount) {
    my $allocation = Allocation->new(bucket => $bucket, amount => $amount);
    push @{$self->parents}, $allocation;
  }
}

package Allocation {
  use Mojo::Base -base;
  has 'bucket';
  has 'amount';
}

package Administrator {
  use Mojo::Base -base;
  has 'user';
  has 'role';
}

1;
