use Test2::V0;

use Types::Callable -types;

{
    package Hoge;
    use overload
        '&{}' => sub {
            my $self = shift;
            return $self->{sub}->(@_);
        };

    sub new {
        my ($class, $sub) = @_;
        return { sub => $sub } => $class;
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
ok !Callable->check('sub { }'), 'string';

done_testing;
