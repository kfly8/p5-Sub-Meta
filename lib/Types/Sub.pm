package Types::Sub;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.13";

use Sub::Meta;
use Sub::Meta::Type;
use Sub::Meta::TypeSub;
use Sub::Meta::CreatorFunction;

use Types::Standard qw(Ref);
use Type::Library
    -base,
    -declare => qw(
        Sub
        StrictSub
        SubMeta
        StrictSubMeta
    );

__PACKAGE__->meta->add_type(
    name   => 'Sub',
    constraint_generator => _gen_sub_constraint_generator('Sub', strict => 0),
);

__PACKAGE__->meta->add_type(
    name   => 'StrictSub',
    constraint_generator => _gen_sub_constraint_generator('StrictSub', strict => 1),
);

__PACKAGE__->meta->add_type(
    name => 'SubMeta',
    constraint_generator => _gen_submeta_constraint_generator('SubMeta', strict => 0),
);

__PACKAGE__->meta->add_type(
    name => 'StrictSubMeta',
    constraint_generator => _gen_submeta_constraint_generator('StrictSubMeta', strict => 1),
);

sub _gen_sub_constraint_generator {
    my ($name, %options) = @_;
    my $strict = $options{strict};

    my $CodeRef = Ref['CODE'];

    return sub {
        return $CodeRef unless @_;

        my $submeta = Sub::Meta->new(@_);
        my $display_name = sprintf('%s[%s]', $name, $submeta->display);

        my $SubMeta = Sub::Meta::Type->new(
            submeta              => $submeta,
            submeta_strict_check => $strict,
            find_submeta         => \&Sub::Meta::CreatorFunction::find_submeta,
            display_name         => $display_name,
        );

        return Sub::Meta::TypeSub->new(
            parent       => $CodeRef,
            display_name => $display_name,
            submeta_type => $SubMeta
        )
    }
}

sub _gen_submeta_constraint_generator {
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


1;
__END__

=encoding utf-8

=head1 NAME

Types::Sub - type constraints for subroutines and Sub::Meta

=head1 SYNOPSIS

    use Test2::V0;
    use Types::Sub -types;
    use Types::Standard -types;

    my $Sub = Sub[
        args    => [Int, Int],
        returns => Int
    ];

    use Function::Parameters;
    use Function::Return;

    fun add(Int $a, Int $b) :Return(Int) {
        return $a + $b
    }

    ok $Sub->check(\&add);
    ok !$Sub->check(sub {});

    done_testing;

=head1 DESCRIPTION

C<Types::Sub> is type library for subroutines and Sub::Meta. This library can be used with Moo/Mo(o|u)se, etc.

=head1 Types

=head2 Sub[`a]

    Sub[
        args    => [Int, Int],
        returns => Int
    ]

A value where C<Ref['CODE']> and check by C<Sub::Meta#is_relaxed_same_interface>.

    use Types::Sub -types;
    use Types::Standard -types;
    use Sub::Meta;

    use Function::Parameters;
    use Function::Return;

    fun distance(Num :$lat, Num :$lng) :Return(Num) { }

    #
    # Sub[`a] is ...
    #
    my $Sub = Sub[
        subname => 'distance',
        args    => { '$lat' => Num, '$lng' => Num },
        returns => Num
    ];

    ok $Sub->check(\&distance);

    #
    # almost equivalent to the following
    #
    my $submeta = Sub::Meta->new(
        subname => 'distance',
        args    => { '$lat' => Num, '$lng' => Num },
        returns => Num
    );

    my $meta = Sub::Meta::CreatorFunction::find_submeta(\&distance);
    ok $submeta->is_relaxed_same_interface($meta);

    done_testing;

If no argument is given, it matches Ref['CODE']. C<Sub[] == Ref['CODE']>.
This helps to keep writing simple when choosing whether or not to use stricter type checking depending on the environment.

    use Devel::StrictMode;

    has callback => (
        is  => 'ro',
        isa => STRICT ? Sub[
            args    => [Int],
            returns => [Int],
        ] : Sub[]
    );

=head2 StrictSub[`a]

A value where C<Ref['CODE']> and check by C<Sub::Meta#is_strict_same_interface>.

=head2 SubMeta[`a]

A value where checking by C<Sub::Meta#is_relaxed_same_interface>.

=head2 StrictSubMeta[`a]

A value where checking by C<Sub::Meta#is_strict_same_interface>.

=head1 SEE ALSO

L<Sub::Meta::Type>

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut
