use Test2::V0;

use Sub::Meta::Returns;
use Sub::Meta::Test qw(test_interface_error_message);

subtest "{ scalar => 'Str' }" => sub {
    my $meta = Sub::Meta::Returns->new({ scalar => 'Str' });
    my @tests = (
        undef, 'must be Sub::Meta::Returns. got: ',
        (bless {} => 'Some'), qr/^must be Sub::Meta::Returns\. got: Some/,
        { scalar => 'Int' }, 'invalid scalar return. got: Int, expected: Str',
        { scalar => 'Str', list => 'Str' }, 'should not have list return',
        { scalar => 'Str', void => 'Str' }, 'should not have void return',
        { scalar => 'Str' }, '', # valid
        { scalar => 'Str', list => undef, void => undef }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};

subtest "{ list => 'Str' }" => sub {
    my $meta = Sub::Meta::Returns->new({ list => 'Str' });
    my @tests = (
        { list => 'Int' }, 'invalid list return. got: Int, expected: Str',
        { list => 'Str', scalar => 'Str' }, 'should not have scalar return',
        { list => 'Str', void => 'Str' }, 'should not have void return',
        { list => 'Str' }, '', # valid
        { list => 'Str', scalar => undef, void => undef }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};

subtest "{ void => 'Str' }" => sub {
    my $meta = Sub::Meta::Returns->new({ void => 'Str' });
    my @tests = (
        { void => 'Int' }, 'invalid void return. got: Int, expected: Str',
        { void => 'Str', scalar => 'Str' }, 'should not have scalar return',
        { void => 'Str', list => 'Str' }, 'should not have list return',
        { void => 'Str' }, '', # valid
        { void => 'Str', scalar => undef, list => undef }, '', # valid
    );
    test_interface_error_message($meta, @tests);
};

done_testing;
