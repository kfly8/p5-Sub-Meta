package Sub::Meta::Finder::Default;
use strict;
use warnings;

sub find_parts {
    my $sub = shift;

    return {
        sub => $sub,
    }
}

1;
