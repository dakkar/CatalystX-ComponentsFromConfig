package CatalystX::ComponentsFromConfig::ModelPlugin;
use Moose::Role;

with 'CatalystX::ComponentsFromConfig::Role::PluginRole'
    => { component_type => 'model' };

1;
