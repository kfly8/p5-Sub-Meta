package Types::SubMeta;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.13";

use Sub::Meta;
use Sub::Meta::Type;
use Sub::Meta::CreatorFunction;

use Type::Library
    -base,
    -declare => qw(
        SubMeta
        StrictSubMeta
    );

__PACKAGE__->meta->add_type(
    _gen_type('SubMeta', strict => 0)
);

__PACKAGE__->meta->add_type(
    _gen_type('StrictSubMeta', strict => 1)
);

sub _gen_type {
    my ($name, %options) = @_;
    my $strict = $options{strict};

    return {
        name => $name,
        constraint_generator => sub {
            my @args = @_;

            my $submeta = Sub::Meta->new(@args);
            my $display_name = sprintf('%s[%s]', $name, $submeta->display);

            return Sub::Meta::Type->new(
                submeta              => $submeta,
                submeta_strict_check => $strict,
                find_submeta         => \&Sub::Meta::CreatorFunction::find_submeta,
                display_name         => $display_name,
            );
        }
    }
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=encoding utf-8

=head1 NAME

Types::SubMeta - subroutine type constraints

=head1 SYNOPSIS

    package Foo {
        use Mouse;
        use Types::SubMeta -types;
        use Types::Standard -types;

        has callback => (
            is  => 'ro',
            isa => SubMeta[
                args    => [Int, Int],
                returns => Int
            ],
            coerce => 0,
        );
    }

    use Sub::WrapInType;
    use Types::Standard -types;

    my $code = wrap_sub([Int, Int] => Int, sub {});

    my $foo = Foo->new(callback => $code);

