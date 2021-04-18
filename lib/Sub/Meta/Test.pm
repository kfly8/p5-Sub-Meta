package Sub::Meta::Test;
use strict;
use warnings;
use parent qw(Exporter);
our @EXPORT_OK = qw(test_submeta test_submeta_parameters test_submeta_param);

use Test2::V0;

sub test_submeta {
    my ($meta, $expected) = @_;
    $expected //= {};

    my $ctx = context;

    is $meta, object {
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
        call has_prototype  => !!$expected->{prototype};
        call has_attribute  => !!$expected->{attribute};
        call has_parameters => !!$expected->{parameters};
        call has_returns    => !!$expected->{returns};
        call has_file       => !!$expected->{file};
        call has_line       => !!$expected->{line};
    };

    $ctx->release;
    return;
};

sub test_submeta_parameters {
    my ($meta, $expected) = @_;
    $expected //= {};

    my $ctx = context;

    is $meta, object {
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
        call has_slurpy               => !!$expected->{slurpy}                 // !!0;
        call has_invocant             => !!$expected->{invocant}               // !!0;
    };
 
    $ctx->release;
    return;
}

sub test_submeta_param {
    my ($meta, $expected) = @_;
    $expected //= {};

    my $ctx = context;

    is $meta, object {
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

    $ctx->release;
    return;
}

1;
