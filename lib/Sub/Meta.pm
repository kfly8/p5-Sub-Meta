package Sub::Meta;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Sub::Identify ();
use Sub::Util ();
use attributes ();

use Sub::Meta::Parameters;
use Sub::Meta::Returns;

BEGIN {
    # for Pure Perl
    $ENV{PERL_SUB_IDENTIFY_PP} = $ENV{PERL_SUB_META_PP};
}

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless \%args => $class;
}

sub sub()         { $_[0]{sub} }
sub subname()     { $_[0]{subname}     ||= $_[0]->_build_subname }
sub fullname()    { $_[0]{fullname}    ||= $_[0]->_build_fullname  }
sub stashname()   { $_[0]{stashname}   ||= $_[0]->_build_stashname }
sub file()        { $_[0]{file}        ||= $_[0]->_build_file }
sub line()        { $_[0]{line}        ||= $_[0]->_build_line }
sub is_constant() { $_[0]{is_constant} ||= $_[0]->_build_is_constant }
sub prototype()   { $_[0]{prototype}   ||= $_[0]->_build_prototype }
sub attribute()   { $_[0]{attribute}   ||= $_[0]->_build_attribute }
sub is_method()   { $_[0]{is_method} }
sub parameters()  { $_[0]{parameters} }
sub returns()     { $_[0]{returns} }

sub set_sub($)         { $_[0]{sub}         = $_[1]; $_[0] }
sub set_subname($)     { $_[0]{subname}     = $_[1]; $_[0] }
sub set_fullname($)    { $_[0]{fullname}    = $_[1]; $_[0] }
sub set_stashname($)   { $_[0]{stashname}   = $_[1]; $_[0] }
sub set_file($)        { $_[0]{file}        = $_[1]; $_[0] }
sub set_line($)        { $_[0]{line}        = $_[1]; $_[0] }
sub set_is_constant($) { $_[0]{is_constant} = $_[1]; $_[0] }
sub set_prototype($)   { $_[0]{prototype}   = $_[1]; $_[0] }
sub set_attribute($)   { $_[0]{attribute}   = $_[1]; $_[0] }
sub set_is_method($)   { $_[0]{is_method}   = $_[1]; $_[0] }
sub set_parameters($)  { my $self = shift; $self->{parameters} = Sub::Meta::Parameters->new(@_); $self }
sub set_returns($)     { my $self = shift; $self->{returns}    = Sub::Meta::Returns->new(@_); $self }

sub _build_subname()     { $_[0]->sub ? Sub::Identify::sub_name($_[0]->sub) : '' }
sub _build_fullname()    { $_[0]->sub ? Sub::Identify::sub_fullname($_[0]->sub) : '' }
sub _build_stashname()   { $_[0]->sub ? Sub::Identify::stash_name($_[0]->sub) : '' }
sub _build_file()        { $_[0]->sub ? (Sub::Identify::get_code_location($_[0]->sub))[0] : '' }
sub _build_line()        { $_[0]->sub ? (Sub::Identify::get_code_location($_[0]->sub))[1] : undef }
sub _build_is_constant() { $_[0]->sub ? Sub::Identify::is_sub_constant($_[0]->sub) : undef }
sub _build_prototype()   { $_[0]->sub ? Sub::Util::prototype($_[0]->sub) : '' }
sub _build_attribute()   { $_[0]->sub ? [ attributes::get($_[0]->sub) ] : undef }

sub apply_subname($) {
    my ($self, $subname) = @_;
    return unless $self->sub;
    Sub::Util::set_subname($subname, $self->sub);
    $self->set_subname($subname);
    return $self;
}

sub apply_prototype($) {
    my ($self, $prototype) = @_;
    return unless $self->sub;
    Sub::Util::set_prototype($prototype, $self->sub);
    $self->set_prototype($prototype);
    return $self;
}

sub apply_attribute {
    my $self = shift;
    my @attribute = @_ == 1 && ref $_[0] ? @{$_[0]} : @_;
    return unless $self->sub;
    {
        no warnings qw(misc);
        attributes->import($self->stashname, $self->sub, @attribute);
    }
    $self->set_attribute($self->_build_attribute);
    return $self;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta - handle subroutine meta information

=head1 SYNOPSIS

    use Sub::Meta;

    sub hello { }
    my $meta = Sub::Meta->new(\&hello);
    $meta->subname; # => hello
    $meta->apply_subname('world'); # rename subroutine name

    # specify parameters types ( without validation )
    $meta->set_parameters( Sub::Meta::Parameters->new(args => [ { type => 'Str' }]) );
    $meta->parameters->args; # => Sub::Meta::Param->new({ type => 'Str' })

    # specify returns types ( without validation )
    $meta->set_returns( Sub::Meta::Returns->new('Str') );
    $meta->returns->scalar; # => 'Str'

=head1 DESCRIPTION

C<Sub::Meta> provides methods to handle subroutine meta information. In addition to information that can be obtained from subroutines using module L<B> etc., subroutines can have meta information such as arguments and return values.

=head1 METHODS

=head2 new

Constructor of C<Sub::Meta>.

=head2 sub

A subroutine reference

=head2 subname

A subroutine name, e.g. C<hello>

=head2 fullname

A subroutine full name, e.g. C<main::hello>

=head2 stashname

A subroutine stash name, e.g. C<main>

=head2 file

A filename where subroutine is defined, e.g. C<path/to/main.pl>.

=head2 line

A line where the definition of subroutine started.

=head2 is_constant

A boolean value indicating whether the subroutine is a constant or not.

=head2 prototype

A prototype of subroutine reference.

=head2 attribute

A attribute of subroutine reference.

=head2 is_method

A boolean value indicating whether the subroutine is a method or not.

=head2 parameters

Parameters object of L<Sub::Meta::Parameters>.

=head2 returns

Returns object of L<Sub::Meta::Returns>.

=head1 SEE ALSO

L<Sub::Identify>, L<Sub::Util>, L<Sub::Info>, L<Function::Paramters::Info>, L<Function::Return::Info>

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut

