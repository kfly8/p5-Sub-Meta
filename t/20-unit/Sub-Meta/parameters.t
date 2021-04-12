use Test2::V0;

use Sub::Meta;
use Test::SubMeta;

subtest 'set_parameters' => sub {
    my $parameters = Sub::Meta::Parameters->new(args => ['Int']);

    my $meta = Sub::Meta->new;
    is $meta->set_parameters($parameters), $meta, 'set_parameters';

    test_meta($meta, {
        parameters => $parameters,
    });
};

#        is $meta->set_args(['Int']), $meta, 'set_args';
#        is $meta->args, Sub::Meta::Parameters->new(args => ['Int'])->args, 'args';
#        is $meta->set_nshift(1), $meta, 'set_nshift';
#        is $meta->nshift, 1, 'nshift';
#        is $meta->set_slurpy('Str'), $meta, 'set_slurpy';
#        is $meta->slurpy, Sub::Meta::Param->new('Str'), 'slurpy';

subtest 'set_nshift' => sub {
    my $meta = Sub::Meta->new(args => ['Str']);
    $meta->set_nshift(1);
    is $meta->nshift, 1;

    $meta->set_is_method(1);
    $meta->set_nshift(1);
    is $meta->nshift, 1;

    like dies { $meta->set_nshift(0) },
    qr/nshift of method cannot be zero/, 'invalid nshift';
};

subtest 'invocant/invocants/set_invocant' => sub {
    my $invocant = Sub::Meta::Param->new(name => '$self');
    my $p1 = Sub::Meta::Param->new(type => 'Str');

    my $meta = Sub::Meta->new(args => [$p1]);
    is $meta->all_args, [ $p1 ];
    is $meta->invocant, undef;

    is $meta->set_invocant($invocant), $meta;
    is $meta->invocant, $invocant;
    is $meta->invocants, [ $invocant ];

    is $meta->all_args, [ $invocant, $p1 ];
    is $meta->args, [$p1];
};



done_testing;
