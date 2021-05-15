package Types::Callable;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.13";

use Type::Library -base;
use Type::Utils -all;

use Types::Standard qw(Ref Overload);

type 'Callable',
    as Ref['CODE'] | Overload['&{}'];

__PACKAGE__->meta->make_immutable;

__END__
