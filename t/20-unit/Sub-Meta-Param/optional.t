use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

subtest 'set_optional' => sub {
    my $param = Sub::Meta::Param->new;

    subtest 'set optional' => sub {
        is $param->set_optional('hoge'), $param;
        test_submeta_param($param, { optional => !!1 });
    };

    subtest 'set 1' => sub {
        is $param->set_optional(1), $param;
        test_submeta_param($param, { optional => !!1 });
    };

    subtest 'set 0' => sub {
        is $param->set_optional(0), $param;
        test_submeta_param($param, { optional => !!0 });
    };

    subtest 'set empty string' => sub {
        is $param->set_optional(''), $param;
        test_submeta_param($param, { optional => !!0 });
    };

    subtest 'set undef, then TRUE' => sub {
        is $param->set_optional(undef), $param;
        test_submeta_param($param, { optional => !!1 });
    };

    subtest 'set optional / no args' => sub {
        is $param->set_optional, $param;
        test_submeta_param($param, { optional => !!1 });
    };
};

subtest 'set_required' => sub {
    my $param = Sub::Meta::Param->new;

    subtest 'set required' => sub {
        is $param->set_required('hoge'), $param;
        is $param->required, !!1;
        test_submeta_param($param, { optional => !!0 });
    };

    subtest 'set 1' => sub {
        is $param->set_required(1), $param;
        is $param->required, !!1;
        test_submeta_param($param, { optional => !!0 });
    };

    subtest 'set 0' => sub {
        is $param->set_required(0), $param;
        is $param->required, !!0;
        test_submeta_param($param, { optional => !!1 });
    };

    subtest 'set empty string' => sub {
        is $param->set_required(''), $param;
        is $param->required, !!0;
        test_submeta_param($param, { optional => !!1 });
    };

    subtest 'set undef, then TRUE' => sub {
        is $param->set_required(undef), $param;
        is $param->required, !!1;
        test_submeta_param($param, { optional => !!0 });
    };

    subtest 'set optional / no args' => sub {
        is $param->set_required, $param;
        is $param->required, !!1;
        test_submeta_param($param, { optional => !!0 });
    };
};

done_testing;
