package Sub::Meta::Returns;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

sub new {
    my $class = shift;
    my %args = @_ == 1 ? ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]}
                       : ( scalar => $_[0], list => $_[0], void => $_[0] )
             : @_;

    bless \%args => $class;
}

sub scalar() :method { $_[0]{scalar} }
sub list()           { $_[0]{list} }
sub void()           { $_[0]{void} }

sub set_scalar($)    { $_[0]{scalar} = $_[1]; $_[0] }
sub set_list($)      { $_[0]{list}   = $_[1]; $_[0] }
sub set_void($)      { $_[0]{void}   = $_[1]; $_[0] }

sub coerce()      { $_[0]{coerce} }
sub set_coerce($) { $_[0]{coerce} = $_[1]; $_[0] }

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta::Returns - It's new $module

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

