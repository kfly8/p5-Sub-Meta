package Types::Sub;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.13";

use Sub::Meta;
use Sub::Meta::Type;

sub _croak { require Carp; goto &Carp::croak }

use Type::Library
    -base,
    -declare => qw(
        Sub
        Method
        StrictSub
        StrictMethod
    );

__PACKAGE__->meta->add_type(_gen_type(
    name      => 'Sub',
    is_method => !!0,
    strict    => !!0,
));

__PACKAGE__->meta->add_type(_gen_type(
    name      => 'Method',
    is_method => !!1,
    strict    => !!0,
));

__PACKAGE__->meta->add_type(_gen_type(
    name      => 'StrictSub',
    is_method => !!0,
    strict    => !!1,
));

__PACKAGE__->meta->add_type(_gen_type(
    name      => 'StrictMethod',
    is_method => !!1,
    strict    => !!1,
));

sub _gen_type {
    my %options = @_;

    return +{
        name => $options{name},
        constraint_generator => sub {
            my @parameters = @_;
            my $submeta = _create_submeta(\@parameters, \%options);
            return Sub::Meta::Type->new(
                submeta      => $submeta,
                strict       => $options{strict},
                display_name => sprintf('%s[%s]', $options{name}, _display_name_parameter($submeta)),
            );
        }
    }
}

sub _create_submeta {
    my ($parameters, $options) = @_;
    my $is_method = $options->{is_method};

    my $v = $parameters->[0];
    if (Scalar::Util::blessed($v) && $v->isa('Sub::Meta')) {
        $v->set_is_method($is_method);
        $v->parameters->set_nshift($is_method) if $v->has_parameters;
        return $v;
    }
    elsif (@$parameters == 2) {
        my ($args, $returns) = @$parameters;
        return Sub::Meta->new(
            args      => $args,
            returns   => $returns,
            is_method => $is_method,
        );
    }
    elsif (ref $v && ref $v eq 'HASH') {
        return Sub::Meta->new(%$v, is_method => $is_method);
    }
    else {
        return _croak "Unsupported parameters";
    }
}

sub _display_name_parameter {
    my $submeta = shift;
    my $s = '';
    $s .= '['. $submeta->parameters->display .']' if $submeta->has_parameters;
    $s .= ' => ' . $submeta->returns->display if $submeta->has_returns;
    return $s;
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=encoding utf-8

=head1 NAME

Types::Sub - subroutine type constraints

=head1 SYNOPSIS

    use Test2::V0;
    use Types::Standard -types;
    use Types::Sub -types;

    my $type = Sub[ [Int,Int] => Int ];

    sub add { ... }
    ok !$type->check(\&add);

    use Function::Parameters;
    use Function::Return;
    fun add_fp(Int, Int) :Return(Int) { ... }

    use Sub::WrapInType;
    ok $type->check(wrap_sub([Int,Int] => Int, sub { ... });

    use Sub::WrapInType::Attribute;
    sub add_swa :WrapSub([Int,Int] => Int) { ... }
    ok $type->check(\&add_swa);

other case

    my $type = Method[ [Str] => Str ];

    my $type = Sub[{
        subname => 'hello',
        is_method => !!1,
    }]

    my $type = Sub[$submeta];

