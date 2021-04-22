use Test2::V0;

use Sub::Meta;
use Sub::Meta::Test qw(test_interface_error_message);

subtest 'Fail: test_interface_error_message' => sub {
    my $events = intercept {
        my $meta = Sub::Meta->new();
        my @tests = (
            { }, '',
            { }, qr//,
            { }, sub {},
        );
        test_interface_error_message($meta, @tests);
    };

    is $events, array {
        event 'Ok';
        event 'Ok';
        event 'Fail';
        end;
    };

    my (undef, undef, $fail) = @$events;
    my $table = $fail->info->[0]{table};
    is $table->{header}, [
        "PATH", "LNs", "GOT", "OP", "CHECK", "LNs"
    ];
    is $table->{rows}, [
        [ '', D(), '', '==', D(), D() ],
    ];
};

done_testing;
