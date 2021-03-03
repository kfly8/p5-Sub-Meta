use Test2::V0;
use lib 't/lib';

use MyMeta;

my $meta = MyMeta->new(
    subname => 'hello',
    args    => ['Str'],
    returns => 'Str',
);

isa_ok $meta,             ('MyMeta',             'Sub::Meta');
isa_ok $meta->parameters, ('MyMeta::Parameters', 'Sub::Meta::Parameters');
isa_ok $meta->returns,    ('MyMeta::Returns',    'Sub::Meta::Returns');
isa_ok $meta->args->[0],  ('MyMeta::Param',      'Sub::Meta::Param');

is $meta->subname, 'hello';
is $meta->parameters, MyMeta::Parameters->new(args => ['Str']);
is $meta->returns, MyMeta::Returns->new('Str');

done_testing;
