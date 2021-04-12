use Test2::V0;

use Sub::Meta;
use Test::SubMeta;

subtest 'set_returns' => sub {
    my $returns = Sub::Meta::Returns->new('Int');

    my $meta = Sub::Meta->new;
    is $meta->set_returns($returns), $meta, 'set_returns';

    test_meta($meta, {
        returns => $returns,
    });
};

#        is $meta->set_args(['Int']), $meta, 'set_args';
#        is $meta->args, Sub::Meta::Parameters->new(args => ['Int'])->args, 'args';
#        is $meta->set_nshift(1), $meta, 'set_nshift';
#        is $meta->nshift, 1, 'nshift';
#        is $meta->set_slurpy('Str'), $meta, 'set_slurpy';
#        is $meta->slurpy, Sub::Meta::Param->new('Str'), 'slurpy';

        $meta->set_returns($obj);
        is $meta->returns, Sub::Meta::Returns->new($obj),
            'if $obj is not Sub::Meta::Returns, $obj will be treated as type';


done_testing;
