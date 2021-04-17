package Sub::Meta::Test;
use strict;
use warnings;
use parent qw(Exporter);
our @EXPORT_OK = qw(test_submeta test_submeta_parameters test_submeta_param);

use Test2::API qw(context);
use Test2::V0;

sub test_submeta {
    my ($meta, $expected) = @_;
    $expected //= {};

    my $ctx = context;

    isa_ok $meta, 'Sub::Meta';
    is $meta->sub,            $expected->{sub}         // undef,  'sub';
    is $meta->subname,        $expected->{subname}     // '',     'subname';
    is $meta->stashname,      $expected->{stashname}   // '',     'stashname';
    is $meta->fullname,       $expected->{fullname}    // '',     'fullname';
    is $meta->subinfo,        $expected->{subinfo}     // [],     'subinfo';
    is $meta->file,           $expected->{file}        // undef,  'file';
    is $meta->line,           $expected->{line}        // undef,  'line';
    is $meta->prototype,      $expected->{prototype}   // undef,  'prototype';
    is $meta->attribute,      $expected->{attribute}   // undef,  'attribute';
    is $meta->parameters,     $expected->{parameters}  // undef,  'parameters';
    is $meta->returns,        $expected->{returns}     // undef,, 'returns';
    is $meta->is_constant,    !!$expected->{is_constant},         'is_constant';
    is $meta->is_method,      !!$expected->{is_method},           'is_method';
    is $meta->has_sub,        !!$expected->{sub},                 'has_sub';
    is $meta->has_subname,    !!$expected->{subname},             'has_subname';
    is $meta->has_stashname,  !!$expected->{stashname},           'has_stashname';
    is $meta->has_prototype,  !!$expected->{prototype},           'has_prototype';
    is $meta->has_attribute,  !!$expected->{attribute},           'has_attribute';
    is $meta->has_parameters, !!$expected->{parameters},          'has_parameters';
    is $meta->has_returns,    !!$expected->{returns},             'has_returns';
    is $meta->has_file,       !!$expected->{file},                'has_file';
    is $meta->has_line,       !!$expected->{line},                'has_line';

    $ctx->release;
    return;
};

sub test_submeta_parameters {
    my ($meta, $expected) = @_;
    $expected //= {};

    my $ctx = context;

    isa_ok $meta, 'Sub::Meta::Parameters';
    is $meta->nshift                   => $expected->{nshift}                   // 0,      'nshift';
    is $meta->slurpy                   => $expected->{slurpy}                   // undef,  'slurpy';
    is $meta->args                     => $expected->{args}                     // [],     'args';
    is $meta->all_args                 => $expected->{all_args}                 // [],     'all_args';
    is $meta->_all_positional_required => $expected->{_all_positional_required} // [],     '_all_positional_required';
    is $meta->positional               => $expected->{positional}               // [],     'positional';
    is $meta->positional_required      => $expected->{positional_required}      // [],     'positional_required';
    is $meta->positional_optional      => $expected->{positional_optional}      // [],     'positional_optional';
    is $meta->named                    => $expected->{named}                    // [],     'named';
    is $meta->named_required           => $expected->{named_required}           // [],     'named_required';
    is $meta->named_optional           => $expected->{named_optional}           // [],     'named_optional';
    is $meta->invocant                 => $expected->{invocant}                 // undef,  'invocant';
    is $meta->invocants                => $expected->{invocants}                // [],     'invocants';
    is $meta->args_min                 => $expected->{args_min}                 // 0,      'args_min';
    is $meta->args_max                 => $expected->{args_max}                 // 0,      'args_max';
    is $meta->has_slurpy               => !!$expected->{slurpy}                 // !!0,    'has_slurpy';
    is $meta->has_invocant             => !!$expected->{invocant}               // !!0,    'has_invocant';
 
    $ctx->release;
    return;
}

sub test_submeta_param {
    my ($meta, $expected) = @_;
    $expected //= {};

    my $ctx = context;
    isa_ok $meta, 'Sub::Meta::Param';
    is $meta->name         => $expected->{name} // '',       'name';
    is $meta->type         => $expected->{type},             'type';
    is $meta->isa_         => $expected->{type},             'isa_';
    is $meta->default      => $expected->{default},          'default';
    is $meta->coerce       => $expected->{coerce},           'coerce';
    is $meta->optional     => $expected->{optional} // !!0,  'optional';
    is $meta->required     => !$expected->{optional},        'required';
    is $meta->named        => $expected->{named}    // !!0,  'named';
    is $meta->positional   => !$expected->{named},           'positional';
    is $meta->invocant     => $expected->{invocant} // !!0,  'invocant';

    is $meta->has_name     => !!$expected->{name},      'has_name';
    is $meta->has_type     => !!$expected->{type},      'has_type';
    is $meta->has_default  => !!$expected->{default},   'has_default';
    is $meta->has_coerce   => !!$expected->{coerce},    'has_coerce';

    $ctx->release;
    return;
}

1;
