package Sub::Meta::Creator;
use strict;
use warnings;

our $VERSION = "0.07";

use List::Util ();
use Sub::Meta;
use Sub::Meta::Finder::Default;

sub sub_meta_class { 'Sub::Meta' }

sub _croak { require Carp; goto &Carp::croak }

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    unless (exists $args{parts_finders}) {
        $args{parts_finders} = [ \&Sub::Meta::Finder::Default::find_parts ];
    }

    unless (ref $args{parts_finders} && ref $args{parts_finders} eq 'ARRAY') {
        _croak 'parts_finders must be an arrayref'
    }

    unless (List::Util::all { ref $_ && ref $_ eq 'CODE' } @{$args{parts_finders}}) {
        _croak 'elements of parts_finders have to be a code reference'
    }

    return bless \%args => $class;
}

sub parts_finders { @{$_[0]{parts_finders}} }

sub create {
    my ($self, $sub) = @_;
    for my $parts_finder ($self->parts_finders) {
        my $parts = $parts_finder->($sub);
        return $self->sub_meta_class->new($parts) if defined $parts;
    }
    return;
}

1;
