use Test2::V0;

use Sub::Meta;
use Sub::Meta::Test qw(test_submeta);

subtest 'empty subroutine' => sub {
    sub test1 {}
    my $meta = Sub::Meta->new;
    is $meta->set_sub(\&test1), $meta, 'set_sub';

    test_submeta($meta, {
        sub         => \&test1,
        subname     => 'test1',
        stashname   => 'main',
        fullname    => 'main::test1',
        subinfo     => ['main', 'test1'],
        file        => __FILE__,
        line        => 7,
        attribute   => [],
    });
};

subtest 'subroutine prototype && attribute' => sub {
    sub test2($) :method {}
    my $meta = Sub::Meta->new;
    is $meta->set_sub(\&test2), $meta, 'set_sub';

    test_submeta($meta, {
        sub         => \&test2,
        subname     => 'test2',
        stashname   => 'main',
        fullname    => 'main::test2',
        subinfo     => ['main', 'test2'],
        file        => __FILE__,
        line        => 24,
        prototype   => '$',
        attribute   => ['method'],
    });
};

done_testing;
