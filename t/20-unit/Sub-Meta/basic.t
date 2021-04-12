use Test2::V0;

use Sub::Meta;
use Test::SubMeta;

subtest 'no arguments meta' => sub {
    my $meta = Sub::Meta->new;
    test_meta($meta);
};

subtest 'set_sub' => sub {
    sub hello($) :method {}
    my $meta = Sub::Meta->new;
    is $meta->set_sub(\&hello), $meta, 'set_sub';

    test_meta($meta, {
        sub         => \&hello,
        subname     => 'hello',
        stashname   => 'main',
        fullname    => 'main::hello',
        subinfo     => ['main', 'hello'],
        file        => __FILE__,
        line        => 12,
        prototype   => '$',
        attribute   => ['method'],
    });
};

subtest 'set_fullname' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_fullname('Foo::Bar::baz'), $meta, 'set_fullname';

    test_meta($meta, {
        subname     => 'baz',
        stashname   => 'Foo::Bar',
        fullname    => 'Foo::Bar::baz',
        subinfo     => ['Foo::Bar', 'baz'],
    });
};

subtest 'set_stashname' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_stashname('Foo::Bar'), $meta, 'set_stashname';

    test_meta($meta, {
        subname     => '',
        stashname   => 'Foo::Bar',
        fullname    => 'Foo::Bar::',
        subinfo     => ['Foo::Bar'],
    });
};

subtest 'set_subinfo' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_subinfo(['A::B', 'c']), $meta, 'set_subinfo';

    test_meta($meta, {
        subname     => 'c',
        stashname   => 'A::B',
        fullname    => 'A::B::c',
        subinfo     => ['A::B', 'c'],
    });
};

subtest 'set_file' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_file('test/file.t'), $meta, 'set_file';

    test_meta($meta, {
        file => 'test/file.t',
    });
};

subtest 'set_line' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_line(999), $meta, 'set_line';

    test_meta($meta, {
        line => 999,
    });
};

subtest 'set_prototype' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_prototype('$;$'), $meta, 'set_prototype';

    test_meta($meta, {
        prototype => '$;$',
    });
};

subtest 'set_attribute' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_attribute(['foo','bar']), $meta, 'set_attribute';

    test_meta($meta, {
        attribute => ['foo','bar'],
    });
};

subtest 'set_parameters' => sub {
    my $parameters = Sub::Meta::Parameters->new(args => ['Int']);

    my $meta = Sub::Meta->new;
    is $meta->set_parameters($parameters), $meta, 'set_parameters';

    test_meta($meta, {
        parameters => $parameters,
    });
};

subtest 'set_returns' => sub {
    my $returns = Sub::Meta::Returns->new('Int');

    my $meta = Sub::Meta->new;
    is $meta->set_returns($returns), $meta, 'set_returns';

    test_meta($meta, {
        returns => $returns,
    });
};

subtest 'set_is_constant' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_is_constant(!!1), $meta, 'set_is_constant';

    test_meta($meta, {
        is_constant => !!1,
    });
};

subtest 'set_is_method' => sub {
    my $meta = Sub::Meta->new;
    is $meta->set_is_method(!!1), $meta, 'set_is_method';

    test_meta($meta, {
        is_method => !!1,
    });
};

done_testing;
