package Sub::Meta::CreatorFunction;
use 5.010;
use strict;
use warnings;

use Module::Find ();
use Class::Load ();

use Sub::Meta::Library;
use Sub::Meta::Creator;

sub find_submeta {
    my $sub = shift;

    if (my $submeta = Sub::Meta::Library->get($sub)) {
        return $submeta;
    }

    state $creator = Sub::Meta::Creator->new(finders => finders());
    if (my $submeta = $creator->create($sub)) {
        return $submeta;
    }
    return;
}

sub finders {
    my @finder_class = Module::Find::findsubmod('Sub::Meta::Finder');
    my @finders;
    for my $finder_class (@finder_class) {
        if (Class::Load::try_load_class($finder_class)) {
            push @finders => $finder_class->can('find_materials');
        }
    }
    return \@finders;
}

1;
