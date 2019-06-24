package Sub::Meta::Parameters;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Carp ();
use Scalar::Util ();

use Sub::Meta::Param;

sub croak { require Carp; Carp::croak(@_) }

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    croak 'parameters reqruires args' unless exists $args{args};

    $args{nshift} = 0 unless exists $args{nshift};
    $args{slurpy} = 0 unless exists $args{slurpy};
    $args{args}   = $class->_normalize_args($args{args});

    my $self = bless \%args => $class;
    $self->_assert_nshift;
    return $self;
}

sub nshift()   { $_[0]{nshift} }
sub slurpy()   { !!$_[0]{slurpy} }
sub args()     { $_[0]{args} }

sub set_nshit($) { $_[0]{nshift} = $_[1]; $_[0]->_assert_nshift; $_[0] }
sub set_slurpy() { $_[0]{slurpy} = !!$_[0]; $_[0] }

sub set_args {
    my $self = shift;
    $self->{args} = $self->_normalize_args(@_);
    return $self;
}

sub _normalize_args {
    my $self = shift;
    my @args = @_ == 1 && ref $_[0] && (ref $_[0] eq 'ARRAY') ? @{$_[0]} : @_;
    [ map { Scalar::Util::blessed($_) ? $_ : Sub::Meta::Param->new($_) } @args ]
}

sub _assert_nshift {
    my $self = shift;
    if (@{$self->all_positional_required} < $self->nshift) {
        croak 'required positional parameters need more than nshift';
    }
}

sub all_positional_required() {
    [ grep { $_->positional && $_->required } @{$_[0]->args} ];
}

sub positional() {
    my $self = shift;
    my @p = grep { $_->positional } @{$self->args};
    splice @p, 0, $self->nshift;
    [ @p ];
}

sub positional_required() {
    my $self = shift;
    my @p = @{$self->all_positional_required};
    splice @p, 0, $self->nshift;
    [ @p ];
}

sub positional_optional() { [ grep { $_->positional && $_->optional } @{$_[0]->args} ] }

sub named()               { [ grep { $_->named                      } @{$_[0]->args} ] }
sub named_required()      { [ grep { $_->named && $_->required      } @{$_[0]->args} ] }
sub named_optional()      { [ grep { $_->named && $_->optional      } @{$_[0]->args} ] }


sub invocant() {
    my $self = shift;
    my $nshift = $self->nshift;
    return undef if $nshift == 0;
    return $self->all_positional_required->[0] if $nshift == 1;
    croak "Can't return a single invocant; this function has $nshift";
}

sub invocants() {
    my $self = shift;
    my @p = @{$self->all_positional_required};
    splice @p, $self->nshift;
    [ @p ]
}

sub args_min() {
    my $self = shift;
    my $r = 0;
    $r += @{$self->all_positional_required};
    $r += @{$self->named_required} * 2;
    $r
}

sub args_max() {
    my $self = shift;
    return 0 + 'Inf' if $self->slurpy || @{$self->named};
    my $r = 0;
    $r += @{$self->all_positional_required};
    $r += @{$self->positional_optional};
    $r
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta::Parameters - It's new $module

=head1 SYNOPSIS

    use Sub::Meta;

=head1 DESCRIPTION

Sub::Meta is ...

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut

