use Test2::V0;

use Sub::Meta::Test qw(test_sub_meta_type);

use Types::SubMeta -types;
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

subtest 'check validation' => sub {
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

subtest 'check constraint_generator' => sub {

    subtest 'args is hash' => sub {
        my $type = Sub[ { a => Int } => Int ];
        isa_ok $type, 'Sub::Meta::Type';
        is $type->submeta->display, 'sub(Int :a) => Int';
    };

    subtest 'empty Sub::Meta' => sub {
        my $meta = Sub::Meta->new;
        my $type = Sub[ $meta ];
        isa_ok $type, 'Sub::Meta::Type';
        is $type->submeta, $meta;
        is $type->display_name, 'Sub[]';
    };

    subtest 'Sub::Meta/ only args' => sub {
        my $meta = Sub::Meta->new(args => ['Int']);
        my $type = Sub[ $meta ];
        isa_ok $type, 'Sub::Meta::Type';
        is $type->submeta, $meta;
        is $type->display_name, 'Sub[[Int]]';
    };
 
    subtest 'Sub::Meta/ only returns' => sub {
        my $meta = Sub::Meta->new(returns => 'Int');
        my $type = Sub[ $meta ];
        isa_ok $type, 'Sub::Meta::Type';
        is $type->submeta, $meta;
        is $type->display_name, 'Sub[ => Int]';
    };

    subtest 'Sub::Meta arguments' => sub {
        my $arguments = {
            args => ['Int', 'Int'],
            returns => 'Int'
        };
        my $type = Sub[ $arguments ];
        isa_ok $type, 'Sub::Meta::Type';
        my $meta = Sub::Meta->new($arguments);
        is $type->submeta->args, $meta->args;
        is $type->submeta->returns, $meta->returns;
        ok !$type->submeta->is_method;
        is $type->display_name, 'Sub[[Int, Int] => Int]';
    };

    subtest 'exceptions' => sub {
        my $obj = bless {}, 'Hello';
        ok dies { Sub[ $obj ] };
        ok dies { Sub[ [Str] ] };
        ok dies { Sub[ '' ] };
        ok dies { Sub[ \''] };
        ok dies { Sub[ sub {} ] };
    };
};

done_testing;
