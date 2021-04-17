use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

subtest 'set_named' => sub {
    my $param = Sub::Meta::Param->new;

    subtest 'set named' => sub {
        is $param->set_named('hoge'), $param;
        test_submeta_param($param, { named => !!1 });
    };

    subtest 'set 1' => sub {
        is $param->set_named(1), $param;
        test_submeta_param($param, { named => !!1 });
    };

    subtest 'set 0' => sub {
        is $param->set_named(0), $param;
        test_submeta_param($param, { named => !!0 });
    };

    subtest 'set empty string' => sub {
        is $param->set_named(''), $param;
        test_submeta_param($param, { named => !!0 });
    };

    subtest 'set undef, then TRUE' => sub {
        is $param->set_named(undef), $param;
        test_submeta_param($param, { named => !!1 });
    };

    subtest 'set named / no args' => sub {
        is $param->set_named, $param;
        test_submeta_param($param, { named => !!1 });
    };
};

subtest 'set_positional' => sub {
    my $param = Sub::Meta::Param->new;

    subtest 'set positional' => sub {
        is $param->set_positional('hoge'), $param;
        is $param->positional, !!1;
        test_submeta_param($param, { named => !!0 });
    };

    subtest 'set 1' => sub {
        is $param->set_positional(1), $param;
        is $param->positional, !!1;
        test_submeta_param($param, { named => !!0 });
    };

    subtest 'set 0' => sub {
        is $param->set_positional(0), $param;
        is $param->positional, !!0;
        test_submeta_param($param, { named => !!1 });
    };

    subtest 'set empty string' => sub {
        is $param->set_positional(''), $param;
        is $param->positional, !!0;
        test_submeta_param($param, { named => !!1 });
    };

    subtest 'set undef, then TRUE' => sub {
        is $param->set_positional(undef), $param;
        is $param->positional, !!1;
        test_submeta_param($param, { named => !!0 });
    };

    subtest 'set named / no args' => sub {
        is $param->set_positional, $param;
        is $param->positional, !!1;
        test_submeta_param($param, { named => !!0 });
    };
};

done_testing;
