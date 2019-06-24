use Test2::V0;

use Sub::Meta::Param;

subtest 'single arg' => sub {
    my $param = Sub::Meta::Param->new('Type');
    is $param->type, 'Type', 'type';
    is $param->name, undef, 'name';
    is $param->default, undef, 'default';
    ok $param->positional, 'positional';
    ok !$param->named, 'named';
    ok $param->required, 'required';
    ok !$param->optional, 'optional';
};

subtest 'hashref arg' => sub {
    my $param = Sub::Meta::Param->new({ type => 'Type', name => 'foo', named => 1, optional => 1, default => 999 });
    is $param->type, 'Type', 'type';
    is $param->name, 'foo', 'name';
    is $param->default, 999, 'default';
    ok !$param->positional, 'positional';
    ok $param->named, 'named';
    ok !$param->required, 'required';
    ok $param->optional, 'optional';
};

subtest 'setter' => sub {
    my $param = Sub::Meta::Param->new;

    is $param->set_name('$foo'), $param, 'set_name';
    is $param->name, '$foo', 'name';
    is $param->set_type('Type'), $param, 'set_type';
    is $param->type, 'Type', 'type';
    is $param->set_default('Default'), $param, 'set_default';
    is $param->default, 'Default', 'default';

    is $param->set_optional, $param, 'set_optional';
    ok $param->optional, 'optional';
    is $param->set_required, $param, 'set_required';
    ok $param->required, 'required';

    is $param->set_positional, $param, 'set_positional';
    ok $param->positional, 'positional';
    is $param->set_named, $param, 'set_named';
    ok $param->named, 'named';
};

subtest 'overload' => sub {
    my $param = Sub::Meta::Param->new({ name => '$foo' });
    is "$param", '$foo', 'overload string';
};

done_testing;
