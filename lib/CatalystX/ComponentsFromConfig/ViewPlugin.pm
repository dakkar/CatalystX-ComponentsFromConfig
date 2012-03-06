package CatalystX::ComponentsFromConfig::ViewPlugin;
use Moose::Role;

with 'CatalystX::ComponentsFromConfig::Role::PluginRole'
    => { component_type => 'view' };

1;
