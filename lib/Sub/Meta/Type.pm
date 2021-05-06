package Sub::Meta::Type;
use 5.010;
use strict;
use warnings;

use parent qw(Type::Tiny);

use Type::Coercion;
use Types::Callable qw(Callable);
use Sub::Meta::CreatorFunction;

sub submeta { my $self = shift; return $self->{submeta} }
sub strict  { my $self = shift; return $self->{strict} }

sub find_submeta         { my ($self, $sub) = @_; return Sub::Meta::CreatorFunction::find_submeta($sub) }
sub find_submeta_inlined { my ($self, $var) = @_; return "Sub::Meta::CreatorFunction::find_submeta($var)" }

#
# The following methods override the methods of Type::Tiny.
#

sub _croak { require Carp; goto &Carp::croak }

sub new {
    my $class = shift;
    my @args = @_;
    my %opts = ( @args == 1 ) ? %{ $args[0] } : @args;

    _croak "Need to supply submeta" unless exists $opts{submeta};
    _croak "Need to supply strict" unless exists $opts{strict};

    return $class->SUPER::new(%opts);
}

sub has_parent { !!1 }

sub parent { Callable }

sub _build_constraint {
    my $self = shift;

    return sub {
        my $other_sub = shift;
        my $other_meta = $self->find_submeta($other_sub);

        if ($self->strict) {
            $self->submeta->is_same_interface($other_meta);
        }
        else {
            $self->submeta->is_relaxed_same_interface($other_meta);
        }
    }
}

sub can_be_inlined { !!1 }

sub inlined {
    my $self = shift;
    return $self->{inlined} ||= $self->_build_inlined;
}

sub _build_inlined {
    my $self = shift;

    return sub {
        my $var = $_;
        my $code = sprintf('my $other = %s;', $self->find_submeta_inlined($var));

        if ($self->strict) {
            $code .= $self->submeta->is_same_interface_inlined('$other');
        }
        else {
            $code .= $self->submeta->is_relaxed_same_interface_inlined('$other');
        }
        return $code;
    }
}

# TODO: Make the error message look like this.
#
# Reference bless( sub { "DUMMY" }, 'Sub::WrapInType' ) did not pass type constraint "Sub[[Int, Int] => Int]"
#   Reason: invalid scalar return. got: Str, expected: Int
#
#   Expected : sub    (Int,Int) => Int
#   Got      : method (Int,Int) => Str
#              ^^^^^^              ^^^
#
sub get_message {
    my $self = shift;
    my $other_sub = shift;

    my $message;
    $message .= $self->SUPER::get_message($other_sub);

    my $other_meta = $self->find_submeta($other_sub);
    my $error_message = $self->strict ? $self->submeta->error_message($other_meta)
                      : $self->submeta->relaxed_error_message($other_meta);

    $message .= sprintf("\n\tReason: %s", $error_message);

    my $display = $self->submeta->display;
    my $other_display = '';
    $other_display = $other_meta->display if $other_meta;

    $message .= "\n";
    $message .= "\tExpected : $display\n";
    $message .= "\tGot      : $other_display\n";

    return $message;
}

# TODO: support Callable coercion
sub _build_coercion {
    my $self = shift;

    return Type::Coercion->new(
        display_name      => "to_${self}",
        type_constraint   => $self,
        type_coercion_map => [
            #Callable() => sub {
            #    my $sub = shift;
            #},
        ],
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

Types::Sub - subroutine type constraints

