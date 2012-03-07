package CatalystX::ComponentsFromConfig::ModelAdaptor;
use Moose;

# ABSTRACT: trait-aware adaptor for Models

extends 'Catalyst::Model';

with 'CatalystX::ComponentsFromConfig::Role::AdaptorRole'
    => { component_type => 'model' };

__PACKAGE__->meta->make_immutable;

1;
