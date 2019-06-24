package Sub::Meta::Param;

use overload
    fallback => 1,
    '""'     => sub { $_[0]->name || '' },
;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? ref $_[0] && (ref $_[0] eq 'HASH') ? %{$_[0]}
                       : ( type => $_[0], named => 0, optional => 0 )
             : @_;

    bless \%args => $class;
}

sub name()       { $_[0]{name} }
sub type()       { $_[0]{type} }
sub default()    { $_[0]{default} }
sub coerce()     { $_[0]{coerce} }
sub optional()   { !!$_[0]{optional} }
sub required()   { !$_[0]{optional} }
sub named()      { !!$_[0]{named} }
sub positional() { !$_[0]{named} }

sub set_name($)      { $_[0]{name}     = $_[1];   $_[0] }
sub set_type($)      { $_[0]{type}     = $_[1];   $_[0] }
sub set_default($)   { $_[0]{default}  = $_[1];   $_[0] }
sub set_coerce($)    { $_[0]{coerce}   = $_[1];   $_[0] }
sub set_optional($;)   { $_[0]{optional} = !!(defined $_[1] ? $_[1] : 1); $_[0] }
sub set_required($;)   { $_[0]{optional} =  !(defined $_[1] ? $_[1] : 1); $_[0] }
sub set_named($;)      { $_[0]{named}    = !!(defined $_[1] ? $_[1] : 1); $_[0] }
sub set_positional($;) { $_[0]{named}    =  !(defined $_[1] ? $_[1] : 1); $_[0] }

1;
