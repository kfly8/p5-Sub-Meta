subtest 'constant' => sub {
    {
        use constant PI => 4 * atan2(1, 1);
        my $m = Sub::Meta->new(sub => \&PI);
        is $m->is_constant, 1;
    }

    {
        sub one() { 1 } ## no critic (RequireFinalReturn)
        my $m = Sub::Meta->new(sub => \&one);
        is $m->is_constant, 1;
    }

    {
        sub two() { return 2 }
        my $m = Sub::Meta->new(sub => \&two);
        ok !$m->is_constant;
    }
};


