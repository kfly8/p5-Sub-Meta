use Test2::V0;

use Sub::Meta::TypeSub;

subtest 'exceptions' => sub {
    like dies { Sub::Meta::TypeSub->new() },   qr/^Need to supply submeta_type/;
    like dies { Sub::Meta::TypeSub->new({}) }, qr/^Need to supply submeta_type/;
};

done_testing;
