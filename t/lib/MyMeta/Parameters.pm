package MyMeta::Parameters;
use strict;
use warnings;
use parent qw(Sub::Meta::Parameters);

use MyMeta::Param;

# override
sub param_class { 'MyMeta::Param' }

1;
