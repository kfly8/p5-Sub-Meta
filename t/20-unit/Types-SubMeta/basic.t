use Test2::V0;

use Types::SubMeta -types;
use Types::Standard -types;

subtest 'check validation' => sub {
    my $case = { args => [Str], returns => Str };
    my $SubMeta = SubMeta[$case];
    my $StrictSubMeta = StrictSubMeta[$case];

    subtest 'fail cases' => sub {
        my @tests = (
            Sub::Meta->new({ }), 'empty arguments',
            Sub::Meta->new({ args => [Int], returns => Str }), 'invalid args',
            Sub::Meta->new({ args => [Str], returns => Int }), 'invalid returns',
            Sub::Meta->new({ args => [Str], returns => [Str,Str]}), 'invalid returns',
            Sub::Meta->new({ args => [Str], returns => Str, is_method => 1 }), 'method(Str) => Str',
        );

        while (my ($v, $message) = splice @tests, 0, 2) {
            ok(!$SubMeta->check($v), "fail: SubMeta - $message");
            ok(!$StrictSubMeta->check($v), "fail: StrictSubMeta - $message");
        }
    };

    subtest 'pass SubMeta and StrictSubMeta' => sub {
        my @tests = (
            Sub::Meta->new({ args => [Str], returns => Str }), 'sub(Str) => Str',
        );

        while (my ($v, $message) = splice @tests, 0, 2) {
            ok($SubMeta->check($v), "pass: SubMeta - $message");
            ok($StrictSubMeta->check($v), "pass: StrictSubMeta - $message");
        }
    };

    subtest 'pass only SubMeta' => sub {
        my @tests = (
            Sub::Meta->new(args => [Str, Str], returns => Str), 'sub(Str, Str) => Str',
            Sub::Meta->new(args => [Str, Int], returns => Str), 'sub(Str, Int) => Str',
        );

        while (my ($v, $message) = splice @tests, 0, 2) {
            ok($SubMeta->check($v), "pass: SubMeta - $message");
            ok(!$StrictSubMeta->check($v), "fail: StrictSubMeta - $message");
        }
    };
};

subtest 'exceptions' => sub {
    ok dies { SubMeta[ [Str] ] };
    ok dies { SubMeta[ '' ] };
    ok dies { SubMeta[ \''] };
    ok dies { SubMeta[ sub {} ] };
};

done_testing;
