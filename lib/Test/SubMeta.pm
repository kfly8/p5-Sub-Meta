package Test::SubMeta;
use strict;
use warnings;
use parent qw(Exporter);
our @EXPORT = qw(test_meta);

use Test2::API qw(context);
use Test2::V0;

sub test_meta {
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
};

1;
