package Foo;
use Moose;

has something => ( is => 'rw' );
has callback => (is => 'ro');

sub doit {
    my ($self) = @_;

    if ($self->callback) {
        $self->callback->($self->something);
    }
}

1;
