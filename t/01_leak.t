use Test2::V0;
use Test::LeakTrace;

use Sub::Meta;
use Sub::Meta::Library;
use Types::Standard -types;

no_leaks_ok {
    my $meta = Sub::Meta->new;
    undef($meta);
} 'Sub::Meta->new';

no_leaks_ok {
    my $meta = Sub::Meta->new(
        args    => [Int, Int],
        returns => Int,
    );
    undef($meta);
} 'Sub::Meta->new(...)';

no_leaks_ok {
    my $sub = sub {};
    my $meta = Sub::Meta->new(sub => $sub);
    Sub::Meta::Library->register($sub, $meta);
    undef($meta);
} 'Sub::Meta->new & use Library';

done_testing;
