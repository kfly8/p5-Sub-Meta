package Types::Sub;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.13";

use Sub::Meta;
use Sub::Meta::Type;
use Sub::Meta::CreatorFunction;

use Types::Standard qw(Ref);
use Type::Library
    -base,
    -declare => qw(
        Sub
        StrictSub
    );

__PACKAGE__->meta->add_type(
    name   => 'Sub',
    constraint_generator => _gen_constraint_generator('Sub', strict => 0),
);

__PACKAGE__->meta->add_type(
    name   => 'StrictSub',
    constraint_generator => _gen_constraint_generator('StrictSub', strict => 1),
);

sub _gen_constraint_generator {
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

        return Type::Tiny->new(
            parent       => $CodeRef,
            display_name => $SubMeta->display_name,
            constraint => sub {
                my $v = $SubMeta->coerce($_);
                return $SubMeta->check($v);
            },
            message => sub {
                my $v = $SubMeta->coerce($_);
                return $SubMeta->get_message($v);
            }
        )
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Types::Sub - type constraints for subroutines

=head1 SYNOPSIS

    use Test2::V0;

    use Types::Sub -types;
    use Types::Standard -types;

    my $Sub = Sub[
        args    => [Int, Int],
        returns => Int
    ];

    subtest 'Sub::WrapInType' => sub {
        use Sub::WrapInType;

        my $add = wrap_sub([Int,Int] => Int, sub {
            my ($a, $b) = @_;
            return $a + $b;
        });

        ok $Sub->check($add);
    };

    subtest 'F/Parameters,Return' => sub {
        use Function::Parameters;
        use Function::Return;

        fun add(Int $a, Int $b) :Return(Int) {
            return $a + $b
        }

        ok $Sub->check(\&add);
    };

    done_testing;

=head1 DESCRIPTION

C<Types::Sub> is a type constraint library suitable for use with Moo/Moose attributes.

=head1 Types

=head2 Sub

Check by C<is_relaxed_same_interface> method

=head2 StrictSub

Check by C<is_strict_same_interface> (= C<is_same_interface>) method

=head1 SEE ALSO

L<Sub::Meta>, L<Types::SubMeta>

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut
