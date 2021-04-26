package Sub::Meta::Test;
use strict;
use warnings;
use parent qw(Exporter);
our @EXPORT_OK = qw(
    sub_meta
    sub_meta_parameters
    sub_meta_param
    test_is_same_interface
    test_interface_error_message
    DummyType
);

use Test2::V0;

sub sub_meta {
    my ($expected) = @_;
    $expected //= {};

    return object {
        prop isa            => 'Sub::Meta';
        call sub            => $expected->{sub}         // undef;
        call subname        => $expected->{subname}     // '';
        call stashname      => $expected->{stashname}   // '';
        call fullname       => $expected->{fullname}    // '';
        call subinfo        => $expected->{subinfo}     // [];
        call file           => $expected->{file}        // undef;
        call line           => $expected->{line}        // undef;
        call prototype      => $expected->{prototype}   // undef;
        call attribute      => $expected->{attribute}   // undef;
        call parameters     => $expected->{parameters}  // undef;
        call returns        => $expected->{returns}     // undef;
        call is_constant    => !!$expected->{is_constant};
        call is_method      => !!$expected->{is_method};

        call has_sub        => !!$expected->{sub};
        call has_subname    => !!$expected->{subname};
        call has_stashname  => !!$expected->{stashname};
        call has_file       => !!$expected->{file};
        call has_line       => !!$expected->{line};
        call has_prototype  => !!$expected->{prototype};
        call has_attribute  => !!$expected->{attribute};
        call has_parameters => !!$expected->{parameters};
        call has_returns    => !!$expected->{returns};
    };
};

sub sub_meta_parameters {
    my ($expected) = @_;
    $expected //= {};

    return object {
        prop isa                      => 'Sub::Meta::Parameters';
        call nshift                   => $expected->{nshift}                   // 0;
        call slurpy                   => $expected->{slurpy}                   // undef;
        call args                     => $expected->{args}                     // [];
        call all_args                 => $expected->{all_args}                 // [];
        call _all_positional_required => $expected->{_all_positional_required} // [];
        call positional               => $expected->{positional}               // [];
        call positional_required      => $expected->{positional_required}      // [];
        call positional_optional      => $expected->{positional_optional}      // [];
        call named                    => $expected->{named}                    // [];
        call named_required           => $expected->{named_required}           // [];
        call named_optional           => $expected->{named_optional}           // [];
        call invocant                 => $expected->{invocant}                 // undef;
        call invocants                => $expected->{invocants}                // [];
        call args_min                 => $expected->{args_min}                 // 0;
        call args_max                 => $expected->{args_max}                 // 0;
        call has_slurpy               => !!$expected->{slurpy};
        call has_invocant             => !!$expected->{invocant};
    };
}

sub sub_meta_param {
    my ($expected) = @_;
    $expected //= {};

    return object {
        prop isa         => 'Sub::Meta::Param';
        call name        => $expected->{name} // '';
        call type        => $expected->{type};
        call isa_        => $expected->{type};
        call default     => $expected->{default};
        call coerce      => $expected->{coerce};
        call optional    => $expected->{optional} // !!0;
        call required    => !$expected->{optional};
        call named       => $expected->{named}    // !!0;
        call positional  => !$expected->{named};
        call invocant    => $expected->{invocant} // !!0;
        call has_name    => !!$expected->{name};
        call has_type    => !!$expected->{type};
        call has_default => !!$expected->{default};
        call has_coerce  => !!$expected->{coerce};
    };
}

sub test_is_same_interface {
    my ($meta, @tests) = @_;

    ## no critic (ProhibitStringyEval)
    my $is_same_interface = eval sprintf('sub { %s }', $meta->is_same_interface_inlined('$_[0]'));
    my $is_child = eval sprintf('sub { %s }', $meta->is_child_inlined('$_[0]'));
    ## use critic

    my $ctx = context;
    my $meta_class = ref $meta;
    while (@tests) {
        my ($pass, $message, $args) = splice @tests, 0, 3;
        my $other = ref $args && ref $args eq 'HASH'
                  ? $meta_class->new($args)
                  : $args;

        my $same = $meta->is_same_interface($other);
        my $same_inlined = $is_same_interface->($other);

        my $child = $meta->is_child($other);
        my $child_inlined = $is_child->($other);

        subtest "should $pass: $message" => sub {
            if ($pass eq 'pass') {
                ok $same, 'is_same_interface';
                ok $same_inlined, 'is_same_interface_inlined';
                ok $child, 'is_child';
                ok $child_inlined, 'is_child_inlined';
            }
            elsif ($pass eq 'pass_child') {
                ok !$same, 'is_same_interface';
                ok !$same_inlined, 'is_same_interface_inlined';
                ok $child, 'is_child';
                ok $child_inlined, 'is_child_inlined';
            }
            elsif($pass eq 'fail') {
                ok !$same, 'is_same_interface';
                ok !$same_inlined, 'is_same_interface_inlined';
                ok !$child, 'is_child';
                ok !$child_inlined, 'is_child_inlined';
            }
        };
    }
    $ctx->release;
    return;
}

sub test_interface_error_message {
    my ($meta, @tests) = @_;

    my $ctx = context;
    my $meta_class = ref $meta;

    while (@tests) {
        my ($pass, $args, $expected) = splice @tests, 0, 3;
        my $other = ref $args && ref $args eq 'HASH'
                  ? $meta_class->new($args)
                  : $args;

        my $got   = $meta->interface_error_message($other);
        my $child = $meta->child_error_message($other);

        subtest "should $pass: $expected" => sub {
            if ($pass eq 'pass') {
                is $got, '', 'interface_error_message';
                is $child, '', 'child_error_message';
            }
            elsif ($pass eq 'pass_child') {
                like $got, $expected, 'interface_error_message';
                is $child, '', 'child_error_message';
            }
            elsif ($pass eq 'fail') {
                like $got, $expected, 'interface_error_message';
                like $child, $expected, 'child_error_message';
            }
        };
    }

    $ctx->release;
    return;
}

{
    package ## no critic (Modules::ProhibitMultiplePackages) # hide from PAUSE 
        DummyType; ## no critic (RequireFilenameMatchesPackage)

    use overload
        fallback => 1,
        '""' => sub { 'DummyType' }
        ;

    sub new {
        my $class = shift;
        return bless {}, $class
    }
};

sub DummyType {
    return DummyType->new
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta::Test - testing utilities for Sub::Meta

=head1 SYNOPSIS

    use Sub::Meta::Test qw(sub_meta sub_meta_parameters sub_meta_param);

    is Sub::Meta->new, sub_meta({
        subname => 'foo'
    }); # => Fail test

    is Sub::Meta::Parameters->new(args => []), sub_meta_parameters({
        args => ['Str'],
    }); # => Fail test

    is Sub::Meta::Param->new, sub_meta_param({
        type => 'Str',
    }); # => Fail test

=head1 DESCRIPTION

This module provides testing utilities for Sub::Meta.

=head2 UTILITIES

=head3 sub_meta

Testing utility for Sub::Meta object.

=head3 sub_meta_parameters

Testing utility for Sub::Meta::Parameters object.

=head3 sub_meta_param

Testing utility for Sub::Meta::Param object.

=head3 test_is_same_interface

Testing utility for is_same_interface method of Sub::Meta,
Sub::Meta::Param, Sub::Meta::Parameters and Sub::Meta::Returns.

=head3 test_interface_error_message

Testing utility for interface_error_message method of Sub::Meta,
Sub::Meta::Parameters and Sub::Meta::Returns.

=head3 DummyType

Return dummy type object that will return the class name when evaluated as a string.

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut
