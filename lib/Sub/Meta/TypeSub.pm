package Sub::Meta::TypeSub;
use 5.010;
use strict;
use warnings;
use parent qw(Type::Tiny);

sub submeta_type { my $self = shift; return $self->{submeta_type} }

#
# The following methods override the methods of Type::Tiny.
#
sub new {
    my $class  = shift;
    my %params = ( @_ == 1 ) ? %{ $_[0] } : @_;

    ## no critic (Subroutines::ProtectPrivateSubs)
    Type::Tiny::_croak "Need to supply submeta_type" unless exists $params{submeta_type};

    return $class->SUPER::new(%params);
}

sub can_be_inlined { return !!0 }

sub _build_constraint { ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;

    return sub {
        my $sub = shift;
        my $other_meta = $self->submeta_type->coerce($sub);
        $self->submeta_type->check($other_meta)
    }
}

sub get_message {
    my $self = shift;
    my $sub = shift;

    my $meta    = $self->submeta_type->coerce($sub);
    my $message = $self->submeta_type->get_message($meta);

    ## no critic (Subroutines::ProtectPrivateSubs);
    my $default = $self->SUPER::_default_message->($_);
    my $s       = Type::Tiny::_dd($_);
    my $m       = Type::Tiny::_dd($meta);
    ## use critic

    return <<"```";
$default
  Sub::Meta of `$s` is $m
  $message
```
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta::TypeSub - type constraints for subroutines

=head1 SYNOPSIS

    use Sub::Meta::TypeSub;
    use Sub::Meta::Type;
    use Sub::Meta;

    my $submeta = Sub::Meta->new(
        args    => [Int,Int],
        returns => Int,
    );

    my $SubMeta = Sub::Meta::Type->new(
        submeta              => $submeta,
        submeta_strict_check => $strict,
        find_submeta         => \&Sub::Meta::CreatorFunction::find_submeta,
        display_name         => $display_name,
    );

    my $type = Sub::Meta::TypeSub->new(
        submeta_type => $SubMeta,
    );
    $type->check(sub {})

=head1 DESCRIPTION

This module provides types for subroutines.

=head1 METHODS

=head2 submeta_type => InstanceOf[Sub::Meta::Type]

=head1 SEE ALSO

L<Types::Sub>

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut
