use Test2::V0;

use Types::Callable -types;

{
    package Hoge; ## no critic (ProhibitMultiplePackages)
    use overload
        '&{}' => sub {
            my $self = shift;
            return $self->{sub}->(@_);
        };

    sub new {
        my ($class, $sub) = @_;
        return bless { sub => $sub } => $class;
    }
}

{
    package Fuga; ## no critic (ProhibitMultiplePackages)
    use overload
        '@{}' => sub { };

    sub new {
        my ($class, $sub) = @_;
        return bless { sub => $sub } => $class;
    }
}

sub foo { }
my $foo  = bless sub { }, 'Foo';
my $hoge = Hoge->new(sub {});

ok Callable->check(\&foo), 'foo';
ok Callable->check(sub { }), 'coderef';
ok Callable->check($foo), 'blessed coderef';
ok Callable->check($hoge), 'overload &{}';

ok !Callable->check(bless {}, 'Boo'), 'boo';
ok !Callable->check({}), 'hashref';
ok !Callable->check([]), 'arrayref';
ok !Callable->check(\''), 'scalarref';
ok !Callable->check('sub { }'), 'string';
ok !Callable->check(Fuga->new(sub {})), 'overload @{}';

done_testing;
