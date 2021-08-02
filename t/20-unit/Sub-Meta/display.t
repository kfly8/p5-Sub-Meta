use Test2::V0;

use Sub::Meta;

sub display { my @args = @_; return Sub::Meta->new(@args)->display }

my @tests = (
    Sub::Meta->new(),
        'sub',
        'sub *(*) => *',

    Sub::Meta->new(is_method => 1),
        'method',
        'method *(*) => *',

    Sub::Meta->new(subname => 'hello', is_method => 0),
        'sub hello',
        'sub hello(*) => *',

    Sub::Meta->new(subname => 'hello', is_method => 1),
        'method hello',
        'method hello(*) => *',

    Sub::Meta->new(args => ['Str']),
        'sub(Str)',
        'sub *(Str,*) => *',

    Sub::Meta->new(args => ['Str','Int']),
        'sub(Str, Int)',
        'sub *(Str, Int,*) => *',

    Sub::Meta->new(args => [{ type => 'Str', name => '$a', named => 0}]),
        'sub(Str $a)',
        'sub *(Str $a,*) => *',

    Sub::Meta->new(args => [{ type => 'Str', name => '$b', named => 1}]),
        'sub(Str :$b)',
        'sub *(Str :$b,*) => *',

    Sub::Meta->new(invocant => {name => '$class'}, args => [{type => 'Str', name => '$a'}]),
        'method($class: Str $a)',
        'method *($class: Str $a,*) => *',

    Sub::Meta->new(invocant => {name => '$class'}, args => []),
        'method($class: )',
        'method *($class: ,*) => *',

    # FIXME: required args ...
    Sub::Meta->new(invocant => {name => '$class'}),
        'sub',
        'sub *(*) => *',

    # FIXME @values,* => @values
    Sub::Meta->new(slurpy => {name => '@values'}, args => []),
        'sub(@values)',
        'sub *(@values,*) => *',

    Sub::Meta->new(returns => 'Int'),
        'sub => Int',
        'sub *(*) => Int',

    Sub::Meta->new(returns => { scalar => 'Int', list => 'Str' }),
        'sub => (scalar => Int, list => Str)',
        'sub *(*) => (scalar => Int, list => Str)',
);

while (my ($meta, $display, $relaxed_display) = splice @tests, 0, 3) {
    is $meta->display, $display;
    is $meta->relaxed_display, $relaxed_display;
}

done_testing;
