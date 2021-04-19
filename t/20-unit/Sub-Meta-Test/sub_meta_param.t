use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(sub_meta_param);

subtest 'Fail: invalid type' => sub {

    my $events = intercept {
        my $meta = Sub::Meta::Param->new('Str');
        is $meta, sub_meta_param({
            type => 'Int',
        });
    };

    is $events, array {
        event 'Fail';
        end;
    };
};

done_testing;
