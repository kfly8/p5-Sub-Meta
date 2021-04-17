use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

my $param = Sub::Meta::Param->new;

subtest 'set invocant' => sub {
    is $param->set_invocant('hoge'), $param;
    test_submeta_param($param, { invocant => !!1 });
};

subtest 'set 1' => sub {
    is $param->set_invocant(1), $param;
    test_submeta_param($param, { invocant => !!1 });
};

subtest 'set 0' => sub {
    is $param->set_invocant(0), $param;
    test_submeta_param($param, { invocant => !!0 });
};

subtest 'set empty string' => sub {
    is $param->set_invocant(''), $param;
    test_submeta_param($param, { invocant => !!0 });
};

subtest 'set undef, then TRUE' => sub {
    is $param->set_invocant(undef), $param;
    test_submeta_param($param, { invocant => !!1 });
};

subtest 'set invocant / no args' => sub {
    is $param->set_invocant, $param;
    test_submeta_param($param, { invocant => !!1 });
};

done_testing;
