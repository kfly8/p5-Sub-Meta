use Test2::V0;

use Sub::Meta;
use Sub::Meta::Test qw(sub_meta);

subtest 'Fail: invalid subname' => sub {

    my $events = intercept {
        my $meta = Sub::Meta->new;
        is $meta, sub_meta({
            subname => 'hoge',
        });
    };

    is $events, array {
        event 'Fail';
        end;
    };
};

done_testing;
