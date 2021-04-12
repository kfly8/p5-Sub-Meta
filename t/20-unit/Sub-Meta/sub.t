use Test2::V0;

use Sub::Meta;
use Test::SubMeta;

subtest 'set_sub' => sub {
    my $meta = Sub::Meta->new;

    subtest 'empty subroutine' => sub {
        sub set_sub_test1 {}
        is $meta->set_sub(\&set_sub_test1), $meta, 'set_sub';

        test_meta($meta, {
            sub         => \&set_sub_test1,
            subname     => 'set_sub_test1',
            stashname   => 'main',
            fullname    => 'main::set_sub_test1',
            subinfo     => ['main', 'set_sub_test1'],
            file        => __FILE__,
            line        => 19,
            attribute   => [],
        });
    };

    subtest 'subroutine prototype && attribute' => sub {
        sub set_sub_test2($) :method {}
        is $meta->set_sub(\&set_sub_test2), $meta, 'set_sub';

        test_meta($meta, {
            sub         => \&set_sub_test2,
            subname     => 'set_sub_test2',
            stashname   => 'main',
            fullname    => 'main::set_sub_test2',
            subinfo     => ['main', 'set_sub_test2'],
            file        => __FILE__,
            line        => 35,
            prototype   => '$',
            attribute   => ['method'],
        });
    };
};

subtest 'set invalid fullname' => sub {
    my $meta = Sub::Meta->new;

    is $meta->set_fullname('invalid'), $meta, 'set_fullname';
    is $meta->subinfo, [], 'subinfo';
};

subtest 'set_subinfo' => sub {
    my $meta = Sub::Meta->new;

    is $meta->subinfo, [], 'subinfo';

    is $meta->set_subinfo(['foo', 'bar']), $meta, 'set_subinfo';
    is $meta->subinfo, ['foo','bar'], 'subinfo';

    is $meta->set_subinfo('hoge', 'fuga'), $meta, 'set_subinfo';
    is $meta->subinfo, ['hoge','fuga'], 'subinfo';
};


subtest 'set_sub' => sub {
    my $meta = Sub::Meta->new;

    is $meta->subinfo, [], 'subinfo 1';

    $meta->set_sub(\&hello);
    is $meta->subinfo, ['main', 'hello'], 'subinfo 2';

    $meta->set_sub(\&hello2);
    is $meta->subinfo, ['main', 'hello2'], 'subinfo 3';
};

done_testing;

