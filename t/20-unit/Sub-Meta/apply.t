use Test2::V0;

use Sub::Meta;
use Test::SubMeta;

use Sub::Identify ();
use Sub::Util ();
use attributes ();

subtest 'apply_subname' => sub {
    sub hello_subname {}
    my $meta = Sub::Meta->new(sub => \&hello_subname);
    is $meta->apply_subname('good_subname'), $meta, 'apply_subname';

    test_meta($meta, {
        sub         => \&hello_subname,
        subname     => 'good_subname',
        stashname   => 'main',
        fullname    => 'main::good_subname',
        subinfo     => ['main', 'good_subname'],
        file        => __FILE__,
        line        => 146,
        prototype   => '',
        attribute   => [],
    });

    is [ Sub::Identify::get_code_info(\&hello_subname) ], ['main','good_subname'], 'code subname';
    is Sub::Util::prototype(\&hello_subname), '', 'code prototype';
    is [ attributes::get(\&hello_subname) ], [], 'code attribute';
};

subtest 'apply_prototype' => sub {
    sub hello_prototype {}
    my $meta = Sub::Meta->new(sub => \&hello_prototype);
    is $meta->apply_prototype('$$'), $meta, 'apply_prototype';

    test_meta($meta, {
        sub         => \&hello_prototype,
        subname     => 'hello_prototype',
        stashname   => 'main',
        fullname    => 'main::hello_prototype',
        subinfo     => ['main', 'hello_prototype'],
        file        => __FILE__,
        line        => 168,
        prototype   => '$$',
        attribute   => [],
    });

    is [ Sub::Identify::get_code_info(\&hello_prototype) ], ['main','hello_prototype'], 'code subname';
    is Sub::Util::prototype(\&hello_prototype), '$$', 'code prototype';
    is [ attributes::get(\&hello_prototype) ], [], 'code attribute';
};

subtest 'apply_attribute' => sub {
    sub hello_attribute {}
    my $meta = Sub::Meta->new(sub => \&hello_attribute);
    is $meta->apply_attribute('method'), $meta, 'apply_attribute';

    test_meta($meta, {
        sub         => \&hello_attribute,
        subname     => 'hello_attribute',
        stashname   => 'main',
        fullname    => 'main::hello_attribute',
        subinfo     => ['main', 'hello_attribute'],
        file        => __FILE__,
        line        => 190,
        prototype   => '',
        attribute   => ['method'],
    });

    is [ Sub::Identify::get_code_info(\&hello_attribute) ], ['main','hello_attribute'], 'code subname';
    is Sub::Util::prototype(\&hello_attribute), '', 'code attribute';
    is [ attributes::get(\&hello_attribute) ], ['method'], 'code attribute';
};

subtest 'apply_meta' => sub {
    sub hello_meta {}
    my $meta = Sub::Meta->new(sub => \&hello_meta);
    my $other = Sub::Meta->new(
        subname   => 'other_meta',
        prototype => '$',
        attribute => ['lvalue', 'method'],
    );

    is $meta->apply_meta($other), $meta, 'apply_meta';

    test_meta($meta, {
        sub         => \&hello_meta,
        subname     => 'other_meta',
        stashname   => 'main',
        fullname    => 'main::other_meta',
        subinfo     => ['main', 'other_meta'],
        file        => __FILE__,
        line        => 212,
        prototype   => '$',
        attribute   => ['lvalue','method'],
    });

    is [ Sub::Identify::get_code_info(\&hello_meta) ], ['main','other_meta'], 'code subname';
    is Sub::Util::prototype(\&hello_meta), '$', 'code attribute';
    is [ attributes::get(\&hello_meta) ], ['lvalue','method'], 'code attribute';
};

done_testing;
