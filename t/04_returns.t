use Test2::V0;

use Sub::Meta::Returns;

sub Int() { bless {}, 'Some::Type::Int' }
sub Str() { bless {}, 'Some::Type::Str' }

subtest 'empty' => sub {
    my $returns = Sub::Meta::Returns->new();

    is $returns->scalar, undef;
    is $returns->list, undef;
    is $returns->void, undef;
    is $returns->coerce, undef;
};

subtest 'sinble object' => sub {
    my $returns = Sub::Meta::Returns->new( Int );

    is $returns->scalar, Int;
    is $returns->list, Int;
    is $returns->void, Int;
    is $returns->coerce, undef;
};

subtest 'sinble string' => sub {
    my $returns = Sub::Meta::Returns->new( 'Int' );

    is $returns->scalar, 'Int';
    is $returns->list, 'Int';
    is $returns->void, 'Int';
    is $returns->coerce, undef;
};

subtest 'arrayref' => sub {
    my $returns = Sub::Meta::Returns->new([ Int, Str ]);

    is $returns->scalar, [ Int, Str ];
    is $returns->list, [ Int, Str ];
    is $returns->void, [ Int, Str ];
    is $returns->coerce, undef;
};

subtest 'hashref' => sub {
    subtest 'empty' => sub {
        my $returns = Sub::Meta::Returns->new({});

        is $returns->scalar, undef;
        is $returns->list, undef;
        is $returns->void, undef;
        is $returns->coerce, undef;
    };

    subtest 'specify scalar' => sub {
        my $returns = Sub::Meta::Returns->new({ scalar => Int });

        is $returns->scalar, Int;
        is $returns->list, undef;
        is $returns->void, undef;
        is $returns->coerce, undef;
    };

    subtest 'specify list' => sub {
        my $returns = Sub::Meta::Returns->new({ list => Int });

        is $returns->scalar, undef;
        is $returns->list, Int;
        is $returns->void, undef;
        is $returns->coerce, undef;
    };

    subtest 'specify void' => sub {
        my $returns = Sub::Meta::Returns->new({ void => Int });

        is $returns->scalar, undef;
        is $returns->list, undef;
        is $returns->void, Int;
        is $returns->coerce, undef;
    };

    subtest 'specify coerce' => sub {
        my $returns = Sub::Meta::Returns->new({ coerce => !!1 });

        is $returns->scalar, undef;
        is $returns->list, undef;
        is $returns->void, undef;
        is $returns->coerce, !!1;
    };

    subtest 'mixed' => sub {
        my $returns = Sub::Meta::Returns->new({ scalar => Int, list => Str, void => [Int, Str], coerce => !!1 });

        is $returns->scalar, Int;
        is $returns->list, Str;
        is $returns->void, [Int, Str];
        is $returns->coerce, !!1;
    };
};

subtest 'list' => sub {
    subtest 'specify scalar' => sub {
        my $returns = Sub::Meta::Returns->new( scalar => Int );

        is $returns->scalar, Int;
        is $returns->list, undef;
        is $returns->void, undef;
        is $returns->coerce, undef;
    };

    subtest 'specify list' => sub {
        my $returns = Sub::Meta::Returns->new( list => Int );

        is $returns->scalar, undef;
        is $returns->list, Int;
        is $returns->void, undef;
        is $returns->coerce, undef;
    };

    subtest 'specify void' => sub {
        my $returns = Sub::Meta::Returns->new( void => Int );

        is $returns->scalar, undef;
        is $returns->list, undef;
        is $returns->void, Int;
        is $returns->coerce, undef;
    };

    subtest 'specify coerce' => sub {
        my $returns = Sub::Meta::Returns->new( coerce => !!1 );

        is $returns->scalar, undef;
        is $returns->list, undef;
        is $returns->void, undef;
        is $returns->coerce, !!1;
    };

    subtest 'mixed' => sub {
        my $returns = Sub::Meta::Returns->new( scalar => Int, list => Str, void => [Int, Str], coerce => !!1 );

        is $returns->scalar, Int;
        is $returns->list, Str;
        is $returns->void, [Int, Str];
        is $returns->coerce, !!1;
    };
};

done_testing;
