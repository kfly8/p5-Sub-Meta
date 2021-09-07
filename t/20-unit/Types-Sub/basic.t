use Test2::V0;

use Types::Sub -types;
use Types::Standard -types;

subtest 'no arguments' => sub {
    ok Sub[] == Ref['CODE'];
};

subtest 'check validation' => sub {
    my $case = { args => [Str], returns => Str };
    my $Sub = Sub[$case];
    my $StrictSub = StrictSub[$case];

    subtest 'fail cases' => sub {
        my @tests = (
            Sub::Meta->new({ }), 'empty arguments',
            Sub::Meta->new({ args => [Int], returns => Str }), 'invalid args',
            Sub::Meta->new({ args => [Str], returns => Int }), 'invalid returns',
            Sub::Meta->new({ args => [Str], returns => [Str,Str]}), 'invalid returns',
            Sub::Meta->new({ args => [Str], returns => Str, is_method => 1 }), 'method(Str) => Str',
        );

        while (my ($meta, $message) = splice @tests, 0, 2) {
            my $v = sub {};
            Sub::Meta::Library->register($v, $meta);
            ok(!$Sub->check($v), "fail: Sub - $message");
            ok(!$StrictSub->check($v), "fail: StrictSub - $message");
        }
    };

    subtest 'pass Sub and StrictSub' => sub {
        my @tests = (
            Sub::Meta->new({ args => [Str], returns => Str }), 'sub(Str) => Str',
        );

        while (my ($meta, $message) = splice @tests, 0, 2) {
            my $v = sub {};
            Sub::Meta::Library->register($v, $meta);
            ok($Sub->check($v), "pass: Sub - $message");
            ok($StrictSub->check($v), "pass: StrictSub - $message");
        }
    };

    subtest 'pass only Sub' => sub {
        my @tests = (
            Sub::Meta->new(args => [Str, Str], returns => Str), 'sub(Str, Str) => Str',
            Sub::Meta->new(args => [Str, Int], returns => Str), 'sub(Str, Int) => Str',
        );

        while (my ($meta, $message) = splice @tests, 0, 2) {
            my $v = sub {};
            Sub::Meta::Library->register($v, $meta);
            ok($Sub->check($v), "pass: Sub - $message");
            ok(!$StrictSub->check($v), "fail: StrictSub - $message");
        }
    };
};

subtest 'message' => sub {
    my $Sub = Sub[
        args    => [Int,Int],
        returns => Int
    ];

    my $message = $Sub->get_message(sub {});
    like $message, qr/did not pass type constraint "Sub\[sub\(Int, Int\) => Int\]"/;
    like $message, qr/Reason/;
    like $message, qr/Expected/;
    like $message, qr/Got/;
};

done_testing;
