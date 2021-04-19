use Test2::V0;

use Sub::Meta::Parameters;
use Sub::Meta::Test qw(sub_meta_parameters);

subtest 'Fail: invalid args' => sub {
    my $events = intercept {
        my $meta = Sub::Meta::Parameters->new(args => []);
        is $meta, sub_meta_parameters({
            args => ['Int'],
        });
    };

    is $events, array {
        event 'Fail';
        end;
    };
};

done_testing;
