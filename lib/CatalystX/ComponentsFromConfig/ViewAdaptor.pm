package CatalystX::ComponentsFromConfig::ViewAdaptor;
use Moose;

# ABSTRACT: trait-aware adaptor for Views

extends 'Catalyst::View';

with 'CatalystX::ComponentsFromConfig::Role::AdaptorRole'
    => { component_type => 'view' };

# I'm not sure why this is needed, but if I put COMPONENT in the
# AdaptorRole, things break
sub COMPONENT {
    my ($class, $app, @rest) = @_;
    my $self = $class->next::method($app, @rest);
    return $self->SUBCOMPONENT($app,@rest);
}

__PACKAGE__->meta->make_immutable;

1;
