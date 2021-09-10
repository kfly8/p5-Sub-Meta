package Sub::Meta::Type;
use 5.010;
use strict;
use warnings;

use parent qw(Type::Tiny);

use Type::Coercion;
use Types::Standard qw(Ref InstanceOf);

sub submeta              { my $self = shift; return $self->{submeta} }
sub submeta_strict_check { my $self = shift; return $self->{submeta_strict_check} }
sub find_submeta         { my $self = shift; return $self->{find_submeta} }

#
# The following methods override the methods of Type::Tiny.
#
sub new {
    my $class  = shift;
    my %params = ( @_ == 1 ) ? %{ $_[0] } : @_;

    ## no critic (Subroutines::ProtectPrivateSubs)
    Type::Tiny::_croak "Need to supply submeta" unless exists $params{submeta};
    Type::Tiny::_croak "Need to supply submeta_strict_check" unless exists $params{submeta_strict_check};
    Type::Tiny::_croak "Need to supply find_submeta" unless exists $params{find_submeta};
    ## use critic

    return $class->SUPER::new(%params);
}

sub has_parent     { return !!0 }
sub can_be_inlined { return !!1 }

sub inlined {
    my $self = shift;
    if (!$self->{inlined}) {
        $self->{inlined} = $self->_build_inlined;
    }
    return $self->{inlined}
}

sub _build_constraint { ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;

    if ($self->submeta_strict_check) {
        return sub {
            my $other_meta = shift;
            $self->submeta->is_strict_same_interface($other_meta);
        }
    }
    else {
        return sub {
            my $other_meta = shift;
            $self->submeta->is_relaxed_same_interface($other_meta);
        }
    }
}

sub _build_inlined {
    my $self = shift;

    if ($self->submeta_strict_check) {
        return sub {
            my $var = $_;
            $self->submeta->is_strict_same_interface_inlined($var);
        }
    }
    else {
        return sub {
            my $var = $_;
            $self->submeta->is_relaxed_same_interface_inlined($var);
        }
    }
}

# e.g.
# Reference bless( sub { "DUMMY" }, 'Sub::WrapInType' ) did not pass type constraint "SubMeta"
#   Reason : invalid scalar return. got: Str, expected: Int
#
#   Expected : sub (Int,Int) => Int
#   Got      : sub (Int,Int) => Str
sub get_message {
    my $self = shift;
    my $other_meta = shift;

    my $default_message = $self->SUPER::get_message($other_meta);

    state $SubMeta = InstanceOf['Sub::Meta'];

    my ($error_message, $expected, $got);
    if ($self->submeta_strict_check) {
        $error_message = $self->submeta->error_message($other_meta);
        $expected      = $self->submeta->display;
        $got           = $SubMeta->check($other_meta) ? $other_meta->display : "";
    }
    else {
        $error_message = $self->submeta->relaxed_error_message($other_meta);
        $expected      = $self->submeta->display;
        $got           = $SubMeta->check($other_meta) ? $other_meta->display : "";
    }

    my $message = <<"```";
$default_message
    Reason : $error_message

    Expected : $expected
    Got      : $got
```

    return $message;
}

sub has_coercion { return !!1 }

sub _build_coercion { ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    my $self = shift;

    return Type::Coercion->new(
        display_name      => "to_${self}",
        type_constraint   => $self,
        type_coercion_map => [
            Ref['CODE'] => sub {
                my $sub = shift;
                return $self->find_submeta->($sub);
            },
        ],
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta::Type - type constraints for Sub::Meta

=head1 SYNOPSIS

    use Sub::Meta::CreatorFunction;

    my $submeta = Sub::Meta->new();
    my $type = Sub::Meta::Type->new(
        submeta              => $submeta,
        submeta_strict_check => !!0,
        find_submeta         => \&Sub::Meta::CreatorFunction::find_submeta,
    );

=head1 DESCRIPTION

This module provides types for Sub::Meta.

=head1 METHODS

=head2 submeta => InstanceOf[Sub::Meta]

=head2 submeta_strict_check => Bool

=head2 find_submeta => CodeRef

=head1 SEE ALSO

L<Types::Sub>

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut
