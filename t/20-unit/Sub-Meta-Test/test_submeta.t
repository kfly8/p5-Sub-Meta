use Test2::V0;

use Sub::Meta;
use Sub::Meta::Test qw(test_submeta);

subtest 'Fail: invalid subname' => sub {

    my $events = intercept {
        my $meta = Sub::Meta->new;
        test_submeta($meta, {
            subname => 'hoge',
        });
    };

    is $events, array {
        event 'Fail';
        end;
    };
};

done_testing;
