use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

my $param = Sub::Meta::Param->new;

subtest 'set $foo' => sub {
    is $param->set_name('$foo'), $param;
    test_submeta_param($param, { name => '$foo' });
};

subtest 'set foo' => sub {
    is $param->set_name('bar'), $param;
    test_submeta_param($param, { name => 'bar' });
};

subtest 'set undef' => sub {
    is $param->set_name(undef), $param;
    test_submeta_param($param, { name => '' });
};

done_testing;
