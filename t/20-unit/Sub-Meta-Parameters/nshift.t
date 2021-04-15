use Test2::V0;



    my $parameters = Sub::Meta::Parameters->new(args => [p()]);

    is $parameters->nshift, 0, 'nshift';
    is $parameters->set_nshift(1), $parameters, 'set_nshift';
    is $parameters->nshift, 1, 'nshift';


