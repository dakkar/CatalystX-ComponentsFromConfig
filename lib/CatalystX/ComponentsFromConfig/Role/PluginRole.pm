package CatalystX::ComponentsFromConfig::Role::PluginRole;
use MooseX::Role::Parameterized;
use CatalystX::InjectComponent;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

parameter component_type => (
    isa => enum(['model','view','controller']),
    required => 1,
);

role {
    my $params = shift;
    my $type = $params->component_type;
    my $uctype = ucfirst($params->component_type);

    after 'setup_components' => sub {
        my $method = "_setup_dynamic_$type";
        shift->$method(@_);
    };

    method "_setup_dynamic_$type" => sub {
        my ($app) = @_;

        my $plugin_config = $app->config->{"${type}s_from_config"} || {};

        my $prefix = $plugin_config->{prefix} || "${uctype}::";

        my $base_class = $plugin_config->{base_class} ||
            "CatalystX::ComponentsFromConfig::${uctype}Adaptor";

        my $config = $app->config || {};

        foreach my $comp_name ( grep { /^\Q$prefix\E/ } keys %$config ) {
            unless ($app->component($comp_name)) {
                CatalystX::InjectComponent->inject(
                    into => $app,
                    component => $base_class,
                    as => $comp_name,
                );
            }
        }
    };
};

1;
