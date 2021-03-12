package Sub::Meta::Finder::SubWrapInType;
use strict;
use warnings;

use Scalar::Util ();

sub find_parts {
    my $sub = shift;

    return unless Scalar::Util::blessed($sub) && $sub->isa('Sub::WrapInType');

    return {
        args      => $sub->params,
        returns   => $sub->returns,
        is_method => $sub->is_method,
        sub       => $sub,
    }
}

1;
