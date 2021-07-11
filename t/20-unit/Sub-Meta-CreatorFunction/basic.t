use Test2::V0;

use Sub::Meta::CreatorFunction;

sub hello { }
my $meta = Sub::Meta->new;

is Sub::Meta::CreatorFunction::find_submeta(\&hello), undef;
Sub::Meta::Library->register(\&hello, $meta);
is Sub::Meta::CreatorFunction::find_submeta(\&hello), $meta;

done_testing;
