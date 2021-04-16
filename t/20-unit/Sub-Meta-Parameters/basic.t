use Test2::V0;

use Sub::Meta::Test qw(test_submeta_parameters);
use POSIX qw(Inf);

use Sub::Meta::Parameters;
use Sub::Meta::Param;

my $p1              = Sub::Meta::Param->new(type => 'Str');
my $p2              = Sub::Meta::Param->new(type => 'Int');
my $p_optional      = Sub::Meta::Param->new(type => 'Int', optional => 1);
my $n1              = Sub::Meta::Param->new(type => 'Str', named => 1);
my $n2              = Sub::Meta::Param->new(type => 'Int', named => 1);
my $n_optional      = Sub::Meta::Param->new(type => 'Int', named => 1, optional => 1);
my $invocant        = Sub::Meta::Param->new(invocant => 1);
my $invocant_self   = Sub::Meta::Param->new(invocant => 1, name => '$self');
my $invocant_class  = Sub::Meta::Param->new(invocant => 1, name => '$class');
my $slurpy          = Sub::Meta::Param->new(type => 'Num', name => '@numbers');


subtest 'exception' => sub {
    like dies { Sub::Meta::Parameters->new() },
        qr/parameters reqruires args/, 'requires args';
};


note '==== TEST args ====';

subtest 'empty args: { args => [] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => []);
    test_submeta_parameters($meta, {
        args                     => [],
        all_args                 => [],
        _all_positional_required => [],
        positional               => [],
        positional_required      => [],
        positional_optional      => [],
        named                    => [],
        named_required           => [],
        named_optional           => [],
    });
};

subtest 'one args: { args => [$p1] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1]);
    test_submeta_parameters($meta, {
        args                     => [$p1],
        all_args                 => [$p1],
        _all_positional_required => [$p1],
        positional               => [$p1],
        positional_required      => [$p1],
        positional_optional      => [],
        args_min                 => 1,
        args_max                 => 1,
    });
};

subtest 'two args: { args => [$p1, $p2] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1, $p2]);
    test_submeta_parameters($meta, {
        args                     => [$p1, $p2],
        all_args                 => [$p1, $p2],
        _all_positional_required => [$p1, $p2],
        positional               => [$p1, $p2],
        positional_required      => [$p1, $p2],
        positional_optional      => [],
        args_min                 => 2,
        args_max                 => 2,
    });
};

subtest 'one optional args: { args => [$p_optional] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p_optional]);
    test_submeta_parameters($meta, {
        args                     => [$p_optional],
        all_args                 => [$p_optional],
        _all_positional_required => [],
        positional               => [$p_optional],
        positional_required      => [],
        positional_optional      => [$p_optional],
        args_min                 => 0,
        args_max                 => 1,
    });
};

subtest 'required and optional args: { args => [$p1, $p_optional] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1, $p_optional]);
    test_submeta_parameters($meta, {
        args                     => [$p1, $p_optional],
        all_args                 => [$p1, $p_optional],
        _all_positional_required => [$p1],
        positional               => [$p1, $p_optional],
        positional_required      => [$p1],
        positional_optional      => [$p_optional],
        args_min                 => 1,
        args_max                 => 2,
    });
};

subtest 'optional and required args: { args => [$p_optional, $p1] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p_optional, $p1]);
    test_submeta_parameters($meta, {
        args                     => [$p_optional, $p1],
        all_args                 => [$p_optional, $p1],
        _all_positional_required => [$p1],
        positional               => [$p_optional, $p1],
        positional_required      => [$p1],
        positional_optional      => [$p_optional],
        args_min                 => 1,
        args_max                 => 2,
    });
};

subtest 'one named args: { args => [$n1] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$n1]);
    test_submeta_parameters($meta, {
        args                     => [$n1],
        all_args                 => [$n1],
        named                    => [$n1],
        named_required           => [$n1],
        named_optional           => [],
        args_min                 => 2,
        args_max                 => Inf,
    });
};

subtest 'two named args: { args => [$n1, $n2] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$n1, $n2]);
    test_submeta_parameters($meta, {
        args                     => [$n1, $n2],
        all_args                 => [$n1, $n2],
        named                    => [$n1, $n2],
        named_required           => [$n1, $n2],
        named_optional           => [],
        args_min                 => 4,
        args_max                 => Inf,
    });
};

subtest 'one named optional args: { args => [$n_optional] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$n_optional]);
    test_submeta_parameters($meta, {
        args                     => [$n_optional],
        all_args                 => [$n_optional],
        named                    => [$n_optional],
        named_required           => [],
        named_optional           => [$n_optional],
        args_min                 => 0,
        args_max                 => Inf,
    });
};

subtest 'named required and named optional args: { args => [$n1, $n_optional] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$n1, $n_optional]);
    test_submeta_parameters($meta, {
        args                     => [$n1, $n_optional],
        all_args                 => [$n1, $n_optional],
        named                    => [$n1, $n_optional],
        named_required           => [$n1],
        named_optional           => [$n_optional],
        args_min                 => 2,
        args_max                 => Inf,
    });
};

subtest 'named optional and named required args: { args => [$n_optional, $n1] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$n_optional, $n1]);
    test_submeta_parameters($meta, {
        args                     => [$n_optional, $n1],
        all_args                 => [$n_optional, $n1],
        named                    => [$n_optional, $n1],
        named_required           => [$n1],
        named_optional           => [$n_optional],
        args_min                 => 2,
        args_max                 => Inf,
    });
};

subtest 'one positional and one named args: { args => [$p1, $n1] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1, $n1]);
    test_submeta_parameters($meta, {
        args                     => [$p1, $n1],
        all_args                 => [$p1, $n1],
        _all_positional_required => [$p1],
        positional               => [$p1],
        positional_required      => [$p1],
        positional_optional      => [],
        named                    => [$n1],
        named_required           => [$n1],
        named_optional           => [],
        args_min                 => 3,
        args_max                 => Inf,
    });
};

subtest 'one named and one positional args: { args => [$n1, $p1] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$n1, $p1]);
    test_submeta_parameters($meta, {
        args                     => [$n1, $p1],
        all_args                 => [$n1, $p1],
        _all_positional_required => [$p1],
        positional               => [$p1],
        positional_required      => [$p1],
        positional_optional      => [],
        named                    => [$n1],
        named_required           => [$n1],
        named_optional           => [],
        args_min                 => 3,
        args_max                 => Inf,
    });
};

subtest 'two positional and one named args: { args => [$p1, $p2 $n1] }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1, $p2, $n1]);
    test_submeta_parameters($meta, {
        args                     => [$p1, $p2, $n1],
        all_args                 => [$p1, $p2, $n1],
        _all_positional_required => [$p1, $p2],
        positional               => [$p1, $p2],
        positional_required      => [$p1, $p2],
        positional_optional      => [],
        named                    => [$n1],
        named_required           => [$n1],
        named_optional           => [],
        args_min                 => 4,
        args_max                 => Inf,
    });
};

note '==== TEST nshift, invocant ====';

subtest 'set nshift: { args => [], nshift => 1 }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [], nshift => 1);
    test_submeta_parameters($meta, {
        nshift                   => 1,
        args                     => [],
        all_args                 => [$invocant],
        _all_positional_required => [$invocant],
        positional               => [],
        positional_required      => [],
        positional_optional      => [],
        invocant                 => $invocant,
        invocants                => [$invocant],
        args_min                 => 1,
        args_max                 => 1,
    });
};

subtest 'set nshift and args: { args => [$p1], nshift => 1 }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1], nshift => 1);
    test_submeta_parameters($meta, {
        nshift                   => 1,
        args                     => [$p1],
        all_args                 => [$invocant, $p1],
        _all_positional_required => [$invocant, $p1],
        positional               => [$p1],
        positional_required      => [$p1],
        positional_optional      => [],
        invocant                 => $invocant,
        invocants                => [$invocant],
        args_min                 => 2,
        args_max                 => 2,
    });
};

subtest 'set invocant: { args => [], invocant => $invocant_self }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [], invocant => $invocant_self);
    test_submeta_parameters($meta, {
        nshift                   => 1,
        args                     => [],
        all_args                 => [$invocant_self],
        _all_positional_required => [$invocant_self],
        positional               => [],
        positional_required      => [],
        positional_optional      => [],
        invocant                 => $invocant_self,
        invocants                => [$invocant_self],
        args_min                 => 1,
        args_max                 => 1,
    });
};

subtest 'set invocant and args: { args => [$p1], invocant => $invocant_self }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1], invocant => $invocant_self);
    test_submeta_parameters($meta, {
        nshift                   => 1,
        args                     => [$p1],
        all_args                 => [$invocant_self, $p1],
        _all_positional_required => [$invocant_self, $p1],
        positional               => [$p1],
        positional_required      => [$p1],
        positional_optional      => [],
        named                    => [],
        named_required           => [],
        named_optional           => [],
        invocant                 => $invocant_self,
        invocants                => [$invocant_self],
        args_min                 => 2,
        args_max                 => 2,
    });
};

note '==== TEST slurpy ====';

subtest 'set slurpy: { args => [], slurpy => $slurpy }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [], slurpy => $slurpy);
    test_submeta_parameters($meta, {
        slurpy                   => $slurpy,
        args                     => [],
        all_args                 => [],
        args_min                 => 0,
        args_max                 => Inf,
    });
};

subtest 'set slurpy and args: { args => [$p1], slurpy => $slurpy }' => sub {
    my $meta = Sub::Meta::Parameters->new(args => [$p1], slurpy => $slurpy);
    test_submeta_parameters($meta, {
        slurpy                   => $slurpy,
        args                     => [$p1],
        all_args                 => [$p1],
        _all_positional_required => [$p1],
        positional               => [$p1],
        positional_required      => [$p1],
        positional_optional      => [],
        args_min                 => 1,
        args_max                 => Inf,
    });
};

done_testing;
