use Test2::V0;

use Sub::Meta;
use Sub::Meta::Parameters;
use Sub::Meta::Returns;

my $p1 = Sub::Meta::Parameters->new(args => ['Str']);
my $p2 = Sub::Meta::Parameters->new(args => ['Int']);

my $r1 = Sub::Meta::Returns->new('Str');
my $r2 = Sub::Meta::Returns->new('Int');

my $obj = bless {} => 'Some';

sub test_interface {
    my ($meta, @tests) = @_;

    my $inline = $meta->is_same_interface_inlined('$_[0]');
    my $is_same_interface = eval sprintf('sub { %s }', $inline); ## no critic (ProhibitStringyEval)

    my $ctx = context;
    while (@tests) {
        my ($result, $message, $args) = splice @tests, 0, 3;
        my $other = ref $args && ref $args eq 'HASH'
                  ? Sub::Meta->new($args)
                  : $args;

        my $res1 = $meta->is_same_interface($other);
        my $res2 = $is_same_interface->($other);

        note "$result : $message";
        if ($result eq 'OK') {
            ok $res1;
            ok $res2;
        }
        elsif ($result eq 'NG') {
            ok !$res1;
            ok !$res2;
        }
    }
    $ctx->release;
    return;
}

subtest "{ subname => 'foo' }" => sub {
    my $meta = Sub::Meta->new({ subname => 'foo' });
    my @tests = (
        NG => 'invalid other'      => undef,
        NG => 'invalid obj'        => $obj,
        NG => 'invalid subname'    => { subname => 'bar' },
        NG => 'undef subname'      => { subname => undef },
        NG => 'invalid parameters' => { subname => 'foo', parameters => $p1 }, ,
        NG => 'invalid returns'    => { subname => 'foo', returns => $r1 }, ,
        OK => 'valid'              => { subname => 'foo' },
        OK => 'valid'              => { fullname => 'path::foo' },
    );
    test_interface($meta, @tests);
};

subtest "no args: {  }" => sub {
    my $meta = Sub::Meta->new({ });
    my @tests = (
        NG => 'invalid subname'    => { subname => 'foo' },
        OK => 'valid'              => {  },
    );
    test_interface($meta, @tests);
};

subtest "one args: { parameters => \$p1 }" => sub {
    my $meta = Sub::Meta->new({ parameters => $p1 });
    my @tests = (
        NG => 'invalid subname'    => { subname => 'foo' },
        NG => 'invalid parameters' => { parameters => $p2 },
        NG => 'no parameters'      => {  },
        NG => 'invalid subname'    => { parameters => $p1, subname => 'foo' }, 
        NG => 'invalid returns'    => { parameters => $p1, returns => $r1 }, 
        OK => 'valid'              => { parameters => $p1 },
    );
    test_interface($meta, @tests);
};

subtest "one args: { returns => \$r1 }" => sub {
    my $meta = Sub::Meta->new({ returns => $r1 });
    my @tests = (
        NG => 'invalid returns'    => { returns => $r2 },
        NG => 'no returns'         => {  },
        NG => 'invalid subname'    => { returns => $r1, subname => 'foo' }, 
        NG => 'invalid parameters' => { returns => $r1, parameters => $p1 },
        OK => 'valid'              => { returns => $r1 },
    );
    test_interface($meta, @tests);
};

subtest "full args: { subname => 'foo', parameters => \$p1, returns => \$r1 }" => sub {
    my $meta = Sub::Meta->new({ subname => 'foo', parameters => $p1, returns => $r1 });
    my @tests = (
        NG => 'invalid subname'    => { subname => 'bar', parameters => $p1, returns => $r1 }, 
        NG => 'invalid parameters' => { subname => 'foo', parameters => $p2, returns => $r1 }, 
        NG => 'invalid returns'    => { subname => 'foo', parameters => $p1, returns => $r2 }, 
        OK => 'valid'              => { subname => 'foo', parameters => $p1, returns => $r1 }, 
        OK => 'valid w/ stashname' => { subname => 'foo', parameters => $p1, returns => $r1, stashname => 'main' },
        OK => 'valid w/ attribute' => { subname => 'foo', parameters => $p1, returns => $r1, attribute => ['method'] },
        OK => 'valid w/ prototype' => { subname => 'foo', parameters => $p1, returns => $r1, prototype => '$' },
    );
    test_interface($meta, @tests);
};

subtest "method: { subname => 'foo', is_method => !!1 }" => sub {
    my $meta = Sub::Meta->new({ subname => 'foo', is_method => !!1 });
    my @tests = (
        NG => 'invalid method' => { subname => 'foo', is_method => !!0 },
        NG => 'invalid method' => { subname => 'foo' }, 
        OK => 'valid method'   => { subname => 'foo', is_method => !!1 }, 
    );
    test_interface($meta, @tests);
};

subtest "not method: { subname => 'foo', is_method => !!0 }" => sub {
    my $meta = Sub::Meta->new({ subname => 'foo', is_method => !!0 });
    my @tests = (
        NG => 'invalid method'  => { subname => 'foo', is_method => !!1 },
        OK => 'valid method'    => { subname => 'foo', is_method => !!0 },
        OK => 'valid method'    => { subname => 'foo' },
    );
    test_interface($meta, @tests);
};

subtest "method: { subname => 'foo', is_method => !!1, parameters => $p1 }" => sub {
    my $meta = Sub::Meta->new({ subname => 'foo', is_method => !!1, parameters => $p1 });
    my @tests = (
        NG => 'invalid method'      => { subname => 'foo', is_method => !!0, parameters => $p1 },
        NG => 'invalid method'      => { subname => 'foo',                parameters => $p1 },
        NG => 'invalid parameters'  => { subname => 'foo', is_method => !!1, parameters => $p2 },
        OK => 'valid method'        => { subname => 'foo', is_method => !!1, parameters => $p1 },
    );
    test_interface($meta, @tests);
};

done_testing;
