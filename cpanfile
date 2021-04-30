requires 'perl', '5.010001';
requires 'Sub::Identify', '0.14';
requires 'Sub::Util', '1.50';
requires 'Carp';
requires 'Scalar::Util';

suggests 'Function::Parameters', '2.000003';
suggests 'Sub::WrapInType', '0.04';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on 'test' => sub {
    requires 'Test2::V0', '0.000135';
};
