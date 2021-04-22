use Test2::V0;

use Sub::Meta;
use Sub::Meta::Test qw(test_interface_error_message);

my $p1 = Sub::Meta::Parameters->new(args => ['Str']);
my $p2 = Sub::Meta::Parameters->new(args => ['Int']);
my $r1 = Sub::Meta::Returns->new('Str');
my $r2 = Sub::Meta::Returns->new('Int');

{
    no warnings qw(redefine); ## no critic (ProhibitNoWarnings)
    *Sub::Meta::Parameters::interface_error_message = sub {
        my ($self, $other) = @_;
        return $self->is_same_interface($other) ? '' : 'invalid parameters';
    };

    *Sub::Meta::Returns::interface_error_message = sub {
        my ($self, $other) = @_;
        return $self->is_same_interface($other) ? '' : 'invalid returns';
    };
}

subtest "{ subname => 'foo' }" => sub {
    my $meta = Sub::Meta->new({ subname => 'foo' });
    my @tests = (
        undef, 'must be Sub::Meta. got: ',
        (bless {} => 'Some'), qr/^must be Sub::Meta\. got: Some/,
        { subname => 'bar' }, 'invalid subname. got: bar, expected: foo',
        { subname => undef }, 'invalid subname. got: , expected: foo',
        { subname => 'foo', is_method => 1 }, 'should not be method',
        { subname => 'foo', parameters => $p1 }, 'should not have parameters',
        { subname => 'foo', returns => $r1 }, 'should not have returns',
        { subname => 'foo' }, '', # valid
        { fullname => 'path::foo' }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};

subtest "no args: {}" => sub {
    my $meta = Sub::Meta->new();
    my @tests = (
        { subname => 'foo' }, 'should not have subname. got: foo',
        { }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};

subtest "method: { is_method => 1 }" => sub {
    my $meta = Sub::Meta->new({ is_method => 1 });
    my @tests = (
        { is_method => 0 }, 'must be method',
        { is_method => 1 }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};

subtest "p1: { parameters => \$p1 }" => sub {
    my $meta = Sub::Meta->new({ parameters => $p1 });
    my @tests = (
        { parameters => $p2 }, 'invalid parameters',
        {  }, 'invalid parameters',
        { parameters => $p1 }, '', #valid
    );
    test_interface_error_message($meta, @tests);
};

subtest "{ returns => \$r1 }" => sub {
    my $meta = Sub::Meta->new({ returns => $r1 });
    my @tests = (
        { returns => $r2 }, 'invalid returns',
        {  }, 'invalid returns',
        { returns => $r1 }, '', #valid
    );
    test_interface_error_message($meta, @tests);
};

done_testing;
