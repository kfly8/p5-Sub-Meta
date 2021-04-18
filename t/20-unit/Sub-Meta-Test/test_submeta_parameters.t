use Test2::V0;

use Sub::Meta::Parameters;
use Sub::Meta::Test qw(test_submeta_parameters);

subtest 'Fail: invalid args' => sub {
    my $events = intercept {
        my $meta = Sub::Meta::Parameters->new(args => []);
        test_submeta_parameters($meta, {
            args => ['Int'],
        });
    };

    is $events, array {
        event 'Fail';
        end;
    };
};

done_testing;
