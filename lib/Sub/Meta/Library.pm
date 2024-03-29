package Sub::Meta::Library;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.15";

use Scalar::Util ();
use Sub::Identify;
use Types::Standard qw(InstanceOf Str Ref);
use Type::Params qw(compile Invocant);

our %INFO;
our %INDEX;

my $SubMeta  = InstanceOf['Sub::Meta'];
my $Callable = Ref['CODE'];

sub register {
    state $check = compile(Invocant, $Callable, $SubMeta);
    my ($class, $sub, $meta) = $check->(@_);

    my $id = Scalar::Util::refaddr $sub;
    my ($stash, $subname) = Sub::Identify::get_code_info($sub);
    $INDEX{$stash}{$subname} = $id;
    $INFO{$id} = $meta;
    return;
}

sub register_list {
    my ($class, @list) = @_;

    for (@list) {
        $class->register(@$_)
    }
    return;
}

sub get {
    my ($class, $sub) = @_;
    return unless $Callable->check($sub);

    my $id = Scalar::Util::refaddr $sub;
    return $INFO{$id}
}

sub get_by_stash_subname {
    my ($class, $stash, $subname) = @_;

    my $id = $INDEX{$stash}{$subname};
    return $INFO{$id} if $id;
    return;
}

sub get_all_subnames_by_stash {
    my ($class, $stash) = @_;

    my $data = $INDEX{$stash};
    return [ sort keys %$data ] if $data;
    return [ ]
}

sub get_all_submeta_by_stash {
    my ($class, $stash) = @_;

    my $data = $INDEX{$stash};
    return [ map { $INFO{$data->{$_}} } sort keys %$data ] if $data;
    return [ ]
}

sub remove {
    state $check = compile(Invocant, $Callable);
    my ($class, $sub) = $check->(@_);

    my $id = Scalar::Util::refaddr $sub;
    my ($stash, $subname) = Sub::Identify::get_code_info($sub);
    delete $INDEX{$stash}{$subname};
    return delete $INFO{$id}
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::Meta::Library - library of Sub::Meta

=head1 SYNOPSIS

    use Sub::Meta;
    use Sub::Meta::Library;

    sub hello { }

    my $meta = Sub::Meta->new(sub => \&hello);

    Sub::Meta::Library->register(\&hello, $meta);
    my $meta = Sub::Meta::Library->get(\&hello);

=head1 METHODS

=head2 register(\&sub, $meta)

Register submeta in refaddr of C<\&sub>.

=head2 register_list(ArrayRef[\&sub, $meta])

Register a list of coderef and submeta.

=head3 get(\&sub)

Get submeta of C<\&sub>.

=head3 get_by_stash_subname($stash, $subname)

Get submeta by stash and subname. e.g. C<get_by_stash_subname('Foo::Bar', 'hello')>

=head3 get_all_subnames_by_stash($stash)

Get all subnames by stash. e.g. C<get_all_subnames_by_stash('Foo::Bar')>;

=head3 get_all_submeta_by_stash($stash)

Get all submeta by stash. e.g. C<get_all_submeta_by_stash('Foo::Bar')>

=head3 remove(\&sub)

Remove submeta of C<\&sub> from the library.

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut
