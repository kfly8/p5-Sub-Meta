[![Build Status](https://travis-ci.org/kfly8/p5-Sub-Meta.svg?branch=master)](https://travis-ci.org/kfly8/p5-Sub-Meta) [![Coverage Status](https://img.shields.io/coveralls/kfly8/p5-Sub-Meta/master.svg?style=flat)](https://coveralls.io/r/kfly8/p5-Sub-Meta?branch=master) [![MetaCPAN Release](https://badge.fury.io/pl/Sub-Meta.svg)](https://metacpan.org/release/Sub-Meta)
# NAME

Sub::Meta - handle subroutine meta information

# SYNOPSIS

```perl
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
```

# DESCRIPTION

`Sub::Meta` provides methods to handle subroutine meta information. In addition to information that can be obtained from subroutines using module [B](https://metacpan.org/pod/B) etc., subroutines can have meta information such as arguments and return values.

# METHODS

## new

Constructor of `Sub::Meta`.

## sub

A subroutine reference

## subname

A subroutine name, e.g. `hello`

## fullname

A subroutine full name, e.g. `main::hello`

## stashname

A subroutine stash name, e.g. `main`

## file

A filename where subroutine is defined, e.g. `path/to/main.pl`.

## line

A line where the definition of subroutine started.

## is\_constant

A boolean value indicating whether the subroutine is a constant or not.

## prototype

A prototype of subroutine reference.

## attribute

A attribute of subroutine reference.

## is\_method

A boolean value indicating whether the subroutine is a method or not.

## parameters

Parameters object of [Sub::Meta::Parameters](https://metacpan.org/pod/Sub::Meta::Parameters).

## returns

Returns object of [Sub::Meta::Returns](https://metacpan.org/pod/Sub::Meta::Returns).

# SEE ALSO

[Sub::Identify](https://metacpan.org/pod/Sub::Identify), [Sub::Util](https://metacpan.org/pod/Sub::Util), [Sub::Info](https://metacpan.org/pod/Sub::Info), [Function::Paramters::Info](https://metacpan.org/pod/Function::Paramters::Info), [Function::Return::Info](https://metacpan.org/pod/Function::Return::Info)

# LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

kfly8 <kfly@cpan.org>
