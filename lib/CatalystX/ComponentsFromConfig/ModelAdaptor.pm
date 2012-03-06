package CatalystX::ComponentsFromConfig::ModelAdaptor;
use Moose;

extends 'Catalyst::Model';

with 'CatalystX::ComponentsFromConfig::Role::AdaptorRole'
    => { component_type => 'model' };

# I'm not sure why this is needed, but if I put COMPONENT in the
# AdaptorRole, things break
sub COMPONENT {
    my ($class, $app, @rest) = @_;
    my $self = $class->next::method($app, @rest);
    return $self->SUBCOMPONENT($app,@rest);
}

__PACKAGE__->meta->make_immutable;

1;
