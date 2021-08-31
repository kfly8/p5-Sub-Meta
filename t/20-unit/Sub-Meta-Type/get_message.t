use Test2::V0;

use Sub::Meta;
use Sub::Meta::Type;

my $submeta = Sub::Meta->new(args => ['Int', 'Int'], returns => 'Int');
my $other = Sub::Meta->new(args => ['Str', 'Int'], returns => 'Str');

my $SubMeta = Sub::Meta::Type->new(
    submeta => $submeta,
    submeta_strict_check => 0,
    find_submeta => sub { },
    display_name => 'SubMeta',
);

my $StrictSubMeta = Sub::Meta::Type->new(
    submeta => $submeta,
    submeta_strict_check => 1,
    find_submeta => sub { },
    display_name => 'StrictSubMeta',
);

## no critic (RegularExpressions::ProhibitComplexRegexes);
subtest 'SubMeta' => sub {
    my $message = $SubMeta->get_message($other);
    like $message, qr/did not pass type constraint "SubMeta"/;
    like $message, qr/Reason\s*:\s*invalid parameters\s*:\s*args\[0\] is invalid. got: Str, expected: Int/;
    like $message, qr/Expected\s*:\s*sub\(Int, Int\) => Int/;
    like $message, qr/Got\s*:\s*sub\(Str, Int\) => Str/;
};

subtest 'StrictSubMeta' => sub {
    my $message = $StrictSubMeta->get_message($other);
    like $message, qr/did not pass type constraint "StrictSubMeta"/;
    like $message, qr/Reason\s*:\s*invalid parameters\s*:\s*args\[0\] is invalid. got: Str, expected: Int/;
    like $message, qr/Expected\s*:\s*sub\(Int, Int\) => Int/;
    like $message, qr/Got\s*:\s*sub\(Str, Int\) => Str/;
};

subtest "empty other/SubMeta" => sub {
    my $message = $SubMeta->get_message("");
    like $message, qr/did not pass type constraint "SubMeta"/;
    like $message, qr/Reason\s*:\s*other must be Sub::Meta./;
    like $message, qr/Expected\s*:\s*sub\(Int, Int\) => Int/;
    like $message, qr/Got\s*:\s*/;
};

subtest "empty other/StrictSubMeta" => sub {
    my $message = $StrictSubMeta->get_message("");
    like $message, qr/did not pass type constraint "StrictSubMeta"/;
    like $message, qr/Reason\s*:\s*other must be Sub::Meta./;
    like $message, qr/Expected\s*:\s*sub\(Int, Int\) => Int/;
    like $message, qr/Got\s*:\s*/;
};

done_testing;
