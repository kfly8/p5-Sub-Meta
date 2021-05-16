use Test2::V0;

use Sub::Meta::Test qw(test_sub_meta_type);

use Types::Sub -types;
use Types::Standard -types;

use Sub::WrapInType;

subtest '[ [Str] => Str]' => sub {
    my $case = [ [Str] => Str ];
    my @tests = (
        fail              => sub {},                                   'empty coderef',
        fail              => wrap_sub([] => Str, sub {}),              'wrap_sub([] => Str)',
        fail              => wrap_sub([Int] => Str, sub {}),           'wrap_sub([Int] => Str)',
        fail              => wrap_sub([Str] => Int, sub {}),           'wrap_sub([Str] => Int)',
        fail              => wrap_sub([Str] => [Str, Str], sub {}),    'wrap_sub([Str] => [Str, Str])',
        pass_StrictSub    => wrap_sub([Str] => Str, sub {}),           'wrap_sub([Str] => Str)',
        pass_StrictSub    => wrap_sub(Str, => Str, sub {}),            'wrap_sub(Str, => Str)',
        pass_Sub          => wrap_sub([Str,Str] => Str, sub {}),       'wrap_sub([Str,Str] => Str)',
        pass_Sub          => wrap_sub([Str,Int] => Str, sub {}),       'wrap_sub([Str,Int] => Str)',
        pass_StrictMethod => wrap_method([Str] => Str, sub {}),        'wrap_method([Str] => Str)',
        pass_Method       => wrap_method([Str,Str] => Str, sub {}),    'wrap_method([Str,Str] => Str)',
        pass_Method       => wrap_method([Str,Int] => Str, sub {}),    'wrap_method([Str,Int] => Str)',
    );
    test_sub_meta_type($case, @tests);
};

done_testing;
