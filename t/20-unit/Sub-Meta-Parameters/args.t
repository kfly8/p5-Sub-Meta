use Test2::V0;

use lib 't/lib';

use Sub::Meta::Parameters;
use MySubMeta::Param;

my $p1 = Sub::Meta::Param->new(type => 'Str');
my $p2 = Sub::Meta::Param->new(type => 'Int');
my $p3 = Sub::Meta::Param->new(type => 'Num');
my $myp = MySubMeta::Param->new(type => 'MyStr');

subtest set_args => sub {
    my $parameters = Sub::Meta::Parameters->new(args => []);

    is $parameters->args, [];
    is $parameters->set_args($p1), $parameters;
    is $parameters->args, [$p1];

    is $parameters->set_args($p2), $parameters;
    is $parameters->args, [$p2];

    like dies { $parameters->set_args($p1, $p2) }, qr/args must be a single reference/;

    is $parameters->set_args([$p1, $p2]), $parameters;
    is $parameters->args, [$p1, $p2];

    is $parameters->set_args($myp), $parameters;
    is $parameters->args, [$myp];

    my $some = bless {}, 'Some';
    is $parameters->set_args($some), $parameters;
    is $parameters->args, [Sub::Meta::Param->new(type => $some)];

    my $sub = sub {};
    is $parameters->set_args($sub), $parameters;
    is $parameters->args, [Sub::Meta::Param->new(type => $sub)];

    is $parameters->set_args({}), $parameters;
    is $parameters->args, [];


};

#subtest 'normalize_args' => sub {
#    my $some = bless {}, 'Some';
#
### no critic (ProtectPrivateSubs)
#    is(Sub::Meta::Parameters->_normalize_args([$some]), [p($some)], 'blessed arg list');
#    is(Sub::Meta::Parameters->_normalize_args(['Foo', 'Bar']), [p('Foo'), p('Bar')], 'arrayref');
#
#    is(Sub::Meta::Parameters->_normalize_args($some), [p($some)], 'single arg');
#
#    like dies { Sub::Meta::Parameters->_normalize_args('Foo', 'Bar') },
#        qr/args must be a reference/, 'cannot use array';
#
#    is(Sub::Meta::Parameters->_normalize_args(
#        { a => 'Foo', b => 'Bar'}),
#        [p(type => 'Foo', name => 'a', named => 1), p(type => 'Bar', name => 'b', named => 1)], 'hashref');
#
#    is(Sub::Meta::Parameters->_normalize_args(
#        { a => { isa => 'Foo' }, b => { isa => 'Bar' } }),
#        [p(type => 'Foo', name => 'a', named => 1), p(type => 'Bar', name => 'b', named => 1)], 'hashref');
#
#    my $foo = sub { 'Foo' };
#    is(Sub::Meta::Parameters->_normalize_args(
#        { a => $foo }),
#        [p(type => $foo, name => 'a', named => 1)], 'hashref');
### use critic
#};

done_testing;

