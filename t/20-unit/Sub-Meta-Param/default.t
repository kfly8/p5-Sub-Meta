use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

my $param = Sub::Meta::Param->new;

subtest 'set default' => sub {
    is $param->set_default('hoge'), $param;
    test_submeta_param($param, { default => 'hoge' });
};

subtest 'set blessed' => sub {
    my $default = bless {}, 'Default';
    is $param->set_default($default), $param;
    test_submeta_param($param, { default => $default });
};

subtest 'set coderef' => sub {
    my $default = sub { 999 };
    is $param->set_default($default), $param;
    test_submeta_param($param, { default => $default });
};

subtest 'set undef' => sub {
    is $param->set_default(undef), $param;
    test_submeta_param($param, { default => undef });
};

done_testing;
