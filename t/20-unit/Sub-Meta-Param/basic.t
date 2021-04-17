use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

subtest 'arg: type => Str' => sub {
    my $param = Sub::Meta::Param->new({ type => 'Str' });
    test_submeta_param($param, {
        type => 'Str',
    });
};

subtest 'arg: name => $a' => sub {
    my $param = Sub::Meta::Param->new({ name => '$a' });
    test_submeta_param($param, {
        name => '$a',
    });
};

subtest 'arg: default => hoge' => sub {
    my $param = Sub::Meta::Param->new({ default => 'hoge' });
    test_submeta_param($param, {
        default => 'hoge',
    });
};

subtest 'arg: coerce => $sub' => sub {
    my $sub = sub { };
    my $param = Sub::Meta::Param->new({ coerce => $sub });
    test_submeta_param($param, {
        coerce => $sub,
    });
};

subtest 'arg: optional => !!1' => sub {
    my $param = Sub::Meta::Param->new({ optional => !!1 });
    test_submeta_param($param, {
        optional => !!1,
    });
};

subtest 'arg: named => !!1' => sub {
    my $param = Sub::Meta::Param->new({ named => !!1 });
    test_submeta_param($param, {
        named => !!1,
    });
};

subtest 'arg: invocant => !!1' => sub {
    my $param = Sub::Meta::Param->new({ invocant => !!1 });
    test_submeta_param($param, {
        invocant => !!1,
    });
};

subtest 'single arg is treated as a type' => sub {
    test_submeta_param(Sub::Meta::Param->new('Str'), {
        type => 'Str',
    });

    test_submeta_param(Sub::Meta::Param->new([]), {
        type => [],
    });

    my $type = sub {};
    test_submeta_param(Sub::Meta::Param->new($type), {
        type => $type,
    });

    my $type2 = bless {}, 'Type';
    test_submeta_param(Sub::Meta::Param->new($type2), {
        type => $type2,
    });
};

subtest 'mixed arg' => sub {
    my $param = Sub::Meta::Param->new({
        type     => 'Int',
        name     => '$num',
        default  => 999,
        coerce   => undef,
        optional => !!1,
        named    => !!1,
    });
    test_submeta_param($param, {
        type     => 'Int',
        name     => '$num',
        default  => 999,
        coerce   => undef,
        optional => !!1,
        named    => !!1,
    });
};

subtest 'other mixed arg' => sub {
    my $default = sub {};
    my $param = Sub::Meta::Param->new({
        type     => 'Int',
        name     => '$num',
        default  => $default,
    });
    test_submeta_param($param, {
        type     => 'Int',
        name     => '$num',
        default  => $default,
        optional => !!0,
        named    => !!0,
    });
};

done_testing;
