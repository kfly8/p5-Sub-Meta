use Test2::V0;

use Sub::Meta::Parameters;
use Sub::Meta::Test qw(test_interface_error_message);

my $Slurpy = Sub::Meta::Param->new("Slurpy");
my $Str = Sub::Meta::Param->new("Str");
my $Int = Sub::Meta::Param->new("Int");

subtest "{ args => [] }" => sub {
    my $meta = Sub::Meta::Parameters->new({ args => [] });
    my @tests = (
        undef, 'must be Sub::Meta::Parameters. got: ',
        (bless {} => 'Some'), qr/^must be Sub::Meta::Parameters\. got: Some/,
        { args => [$Str] }, 'args length is not equal. got: 1, expected: 0', 
        { args => [], slurpy => $Slurpy }, 'should not have slurpy', 
        { args => [], nshift => 1 }, 'nshift is not equal. got: 1, expected: 0', 
        { args => [] }, '', # valid
        { args => [], slurpy => undef }, '', # valid
        { args => [], nshift => 0 }, '', # valid
        { args => [], slurpy => undef, nshift => 0 }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};
 
subtest "one args: { args => [\$Str] }" => sub {
    my $meta = Sub::Meta::Parameters->new({ args => [$Str] });
    my @tests = (
        { args => [$Int] }, 'args[0] is invalid. got: Int, expected: Str',
        { args => [$Str] }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};
 
subtest "two args: { args => [\$Str, \$Int] }" => sub {
    my $meta = Sub::Meta::Parameters->new({ args => [$Str, $Int] });
    my @tests = (
        { args => [$Int, $Str] }, 'args[0] is invalid. got: Int, expected: Str',
        { args => [$Str, $Str] }, 'args[1] is invalid. got: Str, expected: Int',
        { args => [$Str, $Int] }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};
 
subtest "slurpy: { args => [], slurpy => \$Str }" => sub {
    my $meta = Sub::Meta::Parameters->new({ args => [], slurpy => $Str });
    my @tests = (
        { args => [] }, 'invalid slurpy. got: , expected: Str',
        { args => [], slurpy => $Int }, 'invalid slurpy. got: Int, expected: Str',
        { args => [], slurpy => $Str }, '', # 'valid',
    );
    test_interface_error_message($meta, @tests);
};
 
subtest "nshift: { args => [], nshift => 1 }" => sub {
    my $meta = Sub::Meta::Parameters->new({ args => [], nshift => 1 });
    my @tests = (
        { args => [] }, 'nshift is not equal. got: 0, expected: 1',
        { args => [], nshift => 0}, 'nshift is not equal. got: 0, expected: 1',
        { args => [], nshift => 1 }, '', # 'valid',
    );
    test_interface_error_message($meta, @tests);
};
 
done_testing;
