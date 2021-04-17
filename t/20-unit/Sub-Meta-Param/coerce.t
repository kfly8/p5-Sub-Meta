use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

my $param = Sub::Meta::Param->new;

subtest 'set coerce' => sub {
    is $param->set_coerce('hoge'), $param;
    test_submeta_param($param, { coerce => 'hoge' });
};

subtest 'set blessed' => sub {
    my $coerce = bless {}, 'Default';
    is $param->set_coerce($coerce), $param;
    test_submeta_param($param, { coerce => $coerce });
};

subtest 'set coderef' => sub {
    my $coerce = sub { 999 };
    is $param->set_coerce($coerce), $param;
    test_submeta_param($param, { coerce => $coerce });
};

subtest 'set undef' => sub {
    is $param->set_coerce(undef), $param;
    test_submeta_param($param, { coerce => undef });
};

done_testing;
