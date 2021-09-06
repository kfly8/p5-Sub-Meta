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
    name => 'SubMeta',
    constraint_generator => _gen_constraint_generator('SubMeta', strict => 0),
);

__PACKAGE__->meta->add_type(
    name => 'StrictSubMeta',
    constraint_generator => _gen_constraint_generator('StrictSubMeta', strict => 1),
);

sub _gen_constraint_generator {
    my ($name, %options) = @_;
    my $strict = $options{strict};

    return sub {
        my $submeta = Sub::Meta->new(@_);
        my $display_name = sprintf('%s[%s]', $name, $submeta->display);

        return Sub::Meta::Type->new(
            submeta              => $submeta,
            submeta_strict_check => $strict,
            find_submeta         => \&Sub::Meta::CreatorFunction::find_submeta,
            display_name         => $display_name,
        );
    }
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=encoding utf-8

=head1 NAME

Types::SubMeta - type constraints and coercions for Sub::Meta

=head1 SYNOPSIS

    use v5.14;
    use warnings;

    package Foo {
        use Moo;
        use Types::SubMeta qw(SubMeta);
        use Types::Standard -types;

        has callback => (
            is  => 'ro',
            isa => SubMeta[
                args    => [Int, Int],
                returns => Int
            ],
            coerce => 1,
        );
    }

    package main;
    use Test2::V0;

    use Sub::Meta;
    use Sub::WrapInType;
    use Types::Standard -types;

    ok lives { Foo->new( callback => Sub::Meta->new(args => [Int,Int], returns => Int) ) };

    ok dies { Foo->new( callback => Sub::Meta->new(args => [], returns => Int) ) };

    my $foo = Foo->new( callback => wrap_sub([Int,Int] => Int, sub {}) ) }, 'coerce Sub::WrapInType';

    done_testing;

=head1 DESCRIPTION

C<Types::SubMeta> is a type constraint library suitable for use with Moo/Moose attributes.

=head1 Types

=head2 SubMeta

Check by C<is_relaxed_same_interface> method

=head2 StrictSubMeta

Check by C<is_strict_same_interface> (= C<is_same_interface>) method

=head1 SEE ALSO

L<Sub::Meta>, L<Types::Sub>

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut
