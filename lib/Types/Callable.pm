package Types::Callable;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.13";

use overload ();
use Scalar::Util ();

use Type::Library
    -base,
    -declare => qw(
        Callable
    );

__PACKAGE__->meta->add_type({
    name => 'Callable',
    constraint => sub {
        my $sub = shift;
        my $reftype = Scalar::Util::reftype($sub);
        return ( defined $reftype && $reftype eq 'CODE' )
            || defined overload::Method($sub, '&{}');
    },
});

__PACKAGE__->meta->make_immutable;

1;

__END__
