package CatalystX::ComponentsFromConfig::ViewAdaptor;
use Moose;

# ABSTRACT: trait-aware adaptor for Views

extends 'Catalyst::View';

with 'CatalystX::ComponentsFromConfig::Role::AdaptorRole'
    => { component_type => 'view' };

__PACKAGE__->meta->make_immutable;

1;
