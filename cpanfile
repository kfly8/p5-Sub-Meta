requires 'perl', '5.008001';
requires 'Sub::Identify', '0.14';
requires 'Sub::Util', '1.50';
requires 'Carp';
requires 'Scalar::Util';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'JSON::PP';
};
