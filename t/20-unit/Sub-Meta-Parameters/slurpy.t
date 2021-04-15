    my $parameters = Sub::Meta::Parameters->new(args => [p()]);


    ok !$parameters->slurpy, 'slurpy';
    is $parameters->set_slurpy('Str'), $parameters, 'set_slurpy';
    is $parameters->slurpy, p(type => 'Str'), 'slurpy';
    is $parameters->set_slurpy(p(type => 'Int')), $parameters, 'set_slurpy';
    is $parameters->slurpy, p(type => 'Int'), 'slurpy';
    is $parameters->set_slurpy($some), $parameters, 'set_slurpy';
    is $parameters->slurpy, p(type => $some), 'slurpy';


