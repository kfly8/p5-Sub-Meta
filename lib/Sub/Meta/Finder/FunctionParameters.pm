package Sub::Meta::Finder::FunctionParameters;
use strict;
use warnings;

use Function::Parameters;

sub find_parts {
    my $sub = shift;

    my $info = Function::Parameters::info($sub);
    return unless $info;

    my $keyword = $info->keyword;
    my $nshift  = $info->nshift;

    my @args;
    if ($nshift == 1) {
        my $invocant = $info->invocant;
        push @args => {
            type     => $invocant->type,
            name     => $invocant->name,
            invocant => 1,
        }
    }

    for ($info->positional_required) {
        push @args => {
            type       => $_->type,
            name       => $_->name,
            positional => 1,
            required   => 1,
        }
    }

    for ($info->positional_optional) {
        push @args => {
            type       => $_->type,
            name       => $_->name,
            positional => 1,
            required   => 0,
        }
    }

    for ($info->named_required) {
        push @args => {
            type       => $_->type,
            name       => $_->name,
            named      => 1,
            required   => 1,
        }
    }

    for ($info->named_optional) {
        push @args => {
            type       => $_->type,
            name       => $_->name,
            named      => 1,
            required   => 0,
        }
    }

    my $slurpy = $info->slurpy ? {
        name => $info->slurpy->name,
        $info->slurpy->type ? ( type => $info->slurpy->type ) : (),
    } : undef;

    return {
        sub       => $sub,
        nshift    => $nshift,
        is_method => $keyword eq 'method' ? 1 : 0,
        args      => \@args,
        slurpy    => $slurpy,
    }
}

1;
