subtest 'invocant' => sub {
    my $parameters = Sub::Meta::Parameters->new(args => [p('Foo'), p('Bar')]);
    is $parameters->invocant, undef, 'no invocant';
    is $parameters->set_nshift(1), $parameters, 'if set nshift';
    is $parameters->invocant, p(invocant => 1), 'then set default invocant';

    like dies { $parameters->set_nshift(2) }, qr/^Can't set this nshift: /, $parameters;
    like dies { $parameters->set_nshift(undef) }, qr/^Can't set this nshift: /, $parameters;

    is $parameters->set_nshift(0), $parameters, 'if set nshift:0';
    is $parameters->invocant, undef, 'then remove invocant';

    is $parameters->set_invocant(p(name => '$self')), $parameters, 'if set original invocant';
    is $parameters->invocant, p(name => '$self', invocant => 1), 'then original with invocant flag';

    is $parameters->set_invocant({ name => '$class'}), $parameters, 'set_invocant can take hashref';
    is $parameters->invocant, p(name => '$class', invocant => 1);

    my $some = bless {}, 'Some';
    is $parameters->set_invocant($some), $parameters, 'set_invocant can take type';
    is $parameters->invocant, p(type=> $some, invocant => 1);

    my $myparam = MySubMeta::Param->new(name => '$self');
    is $parameters->set_invocant($myparam), $parameters, 'set_invocant can take your Sub::Meta::Param';
    is $parameters->invocant, $myparam->set_invocant(1);
};


