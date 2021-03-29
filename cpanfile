requires 'perl', '5.0101';
requires 'Sub::Identify', '0.14';
requires 'Sub::Util', '1.50';
requires 'Carp';
requires 'Scalar::Util';

on 'develop' => sub {
    requires 'Devel::Cover';
    requires 'Perl::Critic';
};

on 'test' => sub {
    requires 'Test2::V0', '0.000111';
    requires 'JSON::PP';
};

