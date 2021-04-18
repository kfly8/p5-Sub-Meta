use Test2::V0;

use Sub::Meta::Param;
use Sub::Meta::Test qw(test_submeta_param);

subtest 'Fail: invalid type' => sub {

    my $events = intercept {
        my $meta = Sub::Meta::Param->new('Str');
        test_submeta_param($meta, {
            type => 'Int',
        });
    };

    is $events, array {
        event 'Fail';
        end;
    };
};

done_testing;
