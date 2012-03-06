package CatalystX::ComponentsFromConfig::ModelPlugin;
use Moose::Role;

# ABSTRACT: plugin to create Models from configuration

with 'CatalystX::ComponentsFromConfig::Role::PluginRole'
    => { component_type => 'model' };

1;
