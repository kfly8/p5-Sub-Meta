use Test2::V0;

use Sub::Meta::CreatorFunction;

no warnings qw(redefine);
local *Module::Find::findsubmod = sub { return 'Hoge' };

is(Sub::Meta::CreatorFunction::find_submeta(sub {}), undef);

done_testing;
