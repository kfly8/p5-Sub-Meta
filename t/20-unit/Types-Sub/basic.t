use Test2::V0;

use Sub::Meta::Test qw(test_sub_meta_type);

use Types::Sub -types;
use Types::Standard -types;

use Sub::Meta::Library;

sub register_sub {
    my ($args, $returns, $options) = @_;
    $options //= {};

    # Not an empty code reference to generate a new code reference.
    my $sub = sub { $options };

    my $meta = Sub::Meta->new(
        args    => $args,
        returns => $returns,
        sub     => $sub,
        %$options,
    );
    Sub::Meta::Library->register($sub, $meta);
    return $sub;
}

subtest '[ [Str] => Str]' => sub {
    my $case = [ [Str] => Str ];
    my @tests = (
        fail              => sub {},                                             'empty coderef',
        fail              => register_sub([] => Str),                            'sub() => Str',
        fail              => register_sub([Int] => Str),                         'sub(Int) => Str',
        fail              => register_sub([Str] => Int),                         'sub(Str) => Int',
        fail              => register_sub([Str] => [Str, Str]),                  'sub(Str) => [Str, Str]',
        pass_StrictSub    => register_sub([Str] => Str),                         'sub(Str) => Str',
        pass_StrictSub    => register_sub(Str, => Str),                          'sub(Str), => Str',
        pass_Sub          => register_sub([Str,Str] => Str),                     'sub(Str,Str) => Str',
        pass_Sub          => register_sub([Str,Int] => Str),                     'sub(Str,Int) => Str',
        pass_StrictMethod => register_sub([Str] => Str, { is_method => 1 }),     'method(Str) => Str',
        pass_Method       => register_sub([Str,Str] => Str, { is_method => 1 }), 'method(Str,Str) => Str',
        pass_Method       => register_sub([Str,Int] => Str, { is_method => 1 }), 'method(Str,Int) => Str',
    );
    test_sub_meta_type($case, @tests);
};

done_testing;
