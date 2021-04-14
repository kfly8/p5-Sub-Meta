use Test2::V0;

use Sub::Meta;
use Sub::Meta::Test qw(test_submeta);

subtest 'set Sub::Meta::Returns' => sub {
    my $returns = Sub::Meta::Returns->new('Int');

    my $meta = Sub::Meta->new;
    is $meta->set_returns($returns), $meta, 'set_returns';

    test_submeta($meta, {
        returns => $returns,
    });
};

subtest 'set object' => sub {
    my $meta = Sub::Meta->new;
    my $obj = bless {}, 'Foo';

    $meta->set_returns($obj);

    note '$obj will be treated as type';
    test_submeta($meta, {
        returns => Sub::Meta::Returns->new($obj),
    });
};

done_testing;
