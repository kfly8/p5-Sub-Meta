use Test2::V0;

use Sub::Meta;
use Sub::Meta::Type;
use Types::Standard -types;

subtest 'exceptions' => sub {
    like dies { Sub::Meta::Type->new() },                                         qr/^Need to supply submeta/;
    like dies { Sub::Meta::Type->new({}) },                                       qr/^Need to supply submeta/;
    like dies { Sub::Meta::Type->new(submeta => '') },                            qr/^Need to supply submeta_strict_check/;
    like dies { Sub::Meta::Type->new(submeta => '', submeta_strict_check => 1) }, qr/^Need to supply find_submeta/;
};

subtest 'not inlined check' => sub {
    my $submeta = Sub::Meta->new(args => [Str]);

    my $SubMeta = Sub::Meta::Type->new(
        submeta => $submeta,
        submeta_strict_check => 0,
        find_submeta => sub { },
    );

    my $StrictSubMeta = Sub::Meta::Type->new(
        submeta => $submeta,
        submeta_strict_check => 1,
        find_submeta => sub { },
    );

    no warnings qw(redefine);
    local *Sub::Meta::Type::can_be_inlined = sub { return 0 };
    ok $SubMeta->check($submeta);
    ok $StrictSubMeta->check($submeta);
};

done_testing;
