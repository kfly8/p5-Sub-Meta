package Types::Sub::Meta;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Type::Library -base;

my $meta = __PACKAGE__->meta;
$meta->add_type({
    name => "SubMeta",
    name_generator => sub {
        my $s = shift;
        my $sub_meta = shift;

        return sprintf(
            "%s[subname => '%s']",
            $s,
            $sub_meta->subname,
        );
    },
    constraint_generator => sub {
        my $sub_meta = shift;
        
        return sub {
            $sub_meta->is_same_interface($_[0]);
        }
    },
    inline_generator => sub {
        my $sub_meta = shift;

        return sub {
            my ($self, $v) = @_;
            return $sub_meta->inline_is_same_interface($v);
        };
    },
});

__PACKAGE__->meta->make_immutable;

1;
__END__

=encoding utf-8

=head1 NAME

Types::Sub::Meta - Sub::Meta types

=head1 SYNOPSIS

    use Types::Sub::Meta qw(SubMeta);
    use Sub::Meta;

    my $meta = Sub::Meta->new(
        subname => 'hello',
        parameters => {
            args => [
                { type => 'Str' }
            ]
        },
        returns => [
            'Str',
        ]
    );

    my $type = SubMeta[$meta];
    $type->check($meta); # => !!1

=head1 DESCRIPTION

Types::Sub::Meta is ...

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut

