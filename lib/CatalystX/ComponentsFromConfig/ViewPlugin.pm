package CatalystX::ComponentsFromConfig::ViewPlugin;
use Moose::Role;

# ABSTRACT: plugin to create Views from configuration

with 'CatalystX::ComponentsFromConfig::Role::PluginRole'
    => { component_type => 'view' };

1;
