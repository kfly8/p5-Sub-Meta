use Test2::V0;

use Sub::Meta::CreatorFunction;

sub hello {}

subtest 'not coderef' => sub {
    my $meta = Sub::Meta::CreatorFunction::find_submeta('hello');
    is $meta, undef;
};

subtest 'CodeRef' => sub {
    my $meta = Sub::Meta::CreatorFunction::find_submeta(\&hello);
    isa_ok $meta, 'Sub::Meta';
    is $meta->sub, \&hello;
    is $meta->args, [];
};

subtest 'from Library' => sub {
    Sub::Meta::Library->register(\&hello, Sub::Meta->new(
        sub  => \&hello,
        args => ['Int'],
    ));

    my $meta = Sub::Meta::CreatorFunction::find_submeta(\&hello);
    isa_ok $meta, 'Sub::Meta';
    is $meta->sub, \&hello;
    is $meta->args, [Sub::Meta::Param->new('Int')];
};

subtest 'finders' => sub {
    my $finders;
    $finders = Sub::Meta::CreatorFunction::finders();
    is @$finders, scalar @Sub::Meta::CreatorFunction::FINDER_CLASSES;;

    local @Sub::Meta::CreatorFunction::FINDER_CLASSES = qw(Foo Bar);
    $finders = Sub::Meta::CreatorFunction::finders();
    is @$finders, 0;
};

done_testing;
