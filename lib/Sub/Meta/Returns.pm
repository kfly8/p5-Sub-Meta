package Sub::Meta::Returns;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.10";

use Scalar::Util ();

use overload
    fallback => 1,
    eq => \&is_same_interface
    ;

sub new {
    my ($class, @args) = @_;
    my $v = $args[0];
    my %args = @args == 1 ? ref $v && ref $v eq 'HASH' ? %{$v}
                       : ( scalar => $v, list => $v, void => $v )
             : @args;

    return bless \%args => $class;
}

sub scalar() :method { my $self = shift; return $self->{scalar} } ## no critic (ProhibitBuiltinHomonyms)
sub list()           { my $self = shift; return $self->{list} }
sub void()           { my $self = shift; return $self->{void} }
sub coerce()         { my $self = shift; return $self->{coerce} }

sub has_scalar() { my $self = shift; return !!$self->scalar }
sub has_list()   { my $self = shift; return !!$self->list }
sub has_void()   { my $self = shift; return !!$self->void }
sub has_coerce() { my $self = shift; return !!$self->coerce }

sub set_scalar { my ($self, $v) = @_; $self->{scalar} = $v; return $self }
sub set_list   { my ($self, $v) = @_; $self->{list}   = $v; return $self }
sub set_void   { my ($self, $v) = @_; $self->{void}   = $v; return $self }
sub set_coerce { my ($self, $v) = @_; $self->{coerce} = $v; return $self }

sub is_same_interface {
    my ($self, $other) = @_;

    return unless Scalar::Util::blessed($other) && $other->isa('Sub::Meta::Returns');

    if ($self->has_scalar) {
        return unless _eq($self->scalar, $other->scalar)
    }
    else {
        return if $other->has_scalar
    }

    if ($self->has_list) {
        return unless _eq($self->list, $other->list)
    }
    else {
        return if $other->has_list
    }

    if ($self->has_void) {
        return unless _eq($self->void, $other->void)
    }
    else {
        return if $other->has_void
    }

    return !!1;
}

sub is_same_interface_inlined {
    my ($self, $v) = @_;

    my @src;

    push @src => sprintf("Scalar::Util::blessed(%s) && %s->isa('Sub::Meta::Returns')", $v, $v);

    push @src => $self->has_scalar ? _eq_inlined($self->scalar, sprintf('%s->scalar', $v))
                                   : sprintf('!%s->has_scalar', $v);

    push @src => $self->has_list ? _eq_inlined($self->list, sprintf('%s->list', $v))
                                   : sprintf('!%s->has_list', $v);

    push @src => $self->has_void ? _eq_inlined($self->void, sprintf('%s->void', $v))
                                   : sprintf('!%s->has_void', $v);

    return join "\n && ", @src;
}

sub _eq {
    my ($type, $other) = @_;

    if (ref $type && ref $type eq "ARRAY") {
        return unless ref $other eq "ARRAY";
        return unless @$type == @$other;
        for (my $i = 0; $i < @$type; $i++) {
            return unless $type->[$i] eq $other->[$i];
        }
    }
    else {
        return unless $type eq $other;
    }
    return 1;
}

sub interface_error_message {
    my ($self, $other) = @_;

    return sprintf('must be Sub::Meta::Returns. got: %s', $other // '')
        unless Scalar::Util::blessed($other) && $other->isa('Sub::Meta::Returns');

    if ($self->has_scalar) {
        return sprintf('invalid scalar return. got: %s, expected: %s', $other->scalar, $self->scalar)
            unless _eq($self->scalar, $other->scalar);
    }
    else {
        return 'should not have scalar return' if $other->has_scalar;
    }

    if ($self->has_list) {
        return sprintf('invalid list return. got: %s, expected: %s', $other->list, $self->list)
            unless _eq($self->list, $other->list);
    }
    else {
        return 'should not have list return' if $other->has_list;
    }

    if ($self->has_void) {
        return sprintf('invalid void return. got: %s, expected: %s', $other->void, $self->void)
            unless _eq($self->void, $other->void);
    }
    else {
        return 'should not have void return' if $other->has_void;
    }
    return '';
}

sub _eq_inlined {
    my ($type, $v) = @_;

    my @src;
    if (ref $type && ref $type eq "ARRAY") {
        push @src => sprintf('ref %s eq "ARRAY"', $v);
        push @src => sprintf('%d == @{%s}', scalar @$type, $v);
        for (my $i = 0; $i < @$type; $i++) {
            push @src => sprintf('"%s" eq %s->[%d]', $type->[$i], $v, $i);
        }
    }
    else {
        push @src => sprintf('"%s" eq %s', $type, $v);
    }

    return join "\n && ", @src;
}

sub display {
    my $self = shift;

    if (_eq($self->scalar, $self->list) && _eq($self->list, $self->void)) {
        return $self->scalar . '';
    }
    else {
        my @r = map { $self->$_ ? "$_ => @{[$self->$_]}" : () } qw(scalar list void);
        return "(@{[join ', ', @r]})";
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta::Returns - meta information about return values

=head1 SYNOPSIS

    use Sub::Meta::Returns;

    my $r = Sub::Meta::Returns->new(
        scalar  => 'Int',      # optional
        list    => 'ArrayRef', # optional
        void    => 'Void',     # optional
    );

    $r->scalar; # 'Int'
    $r->list;   # 'ArrayRef'
    $r->void;   # 'Void'

=head1 METHODS

=head2 new

Constructor of C<Sub::Meta::Returns>.

=head2 ACCESSORS

=head3 scalar

A type for value when called in scalar context.

=head3 set_scalar($scalar)

Setter for C<scalar>.

=head3 list

A type for value when called in list context.

=head3 set_list($list)

Setter for C<list>.

=head3 void

A type for value when called in void context.

=head3 set_void($void)

Setter for C<void>.

=head3 coerce

coercions.

=head3 set_coerce($bool)

Setter for C<coerce>.

=head2 METHODS

=head3 is_same_interface($other_meta)

A boolean value indicating whether C<Sub::Meta::Returns> object is same or not.
Specifically, check whether C<scalar>, C<list> and C<void> are equal.

=head3 is_same_interface_inlined($other_meta_inlined)

Returns inlined C<is_same_interface> string.

=head3 interface_error_message($other_meta)

Return the error message when the interface does not match.

=head3 display

Returns the display of Sub::Meta::Returns:

    use Sub::Meta::Returns;
    use Types::Standard qw(Tuple Str);
    my $meta = Sub::Meta::Returns->new(Tuple[Str,Str]);
    $meta->display; # 'Tuple[Str,Str]'

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut

