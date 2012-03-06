package CatalystX::ModelsFromConfig::Plugin;
use strict;
use warnings;
use CatalystX::InjectComponent;

after 'setup_components' => sub { shift->_setup_dynamic_models(@_); };

sub _setup_dynamic_models {
    my ($app) = @_;

    my $plugin_config = $app->config->{models_from_config} || {};
    my $prefix = $plugin_config->{prefix} || 'Model::';
    my $base_class = $plugin_config->{base_class} ||
        'CatalystX::ModelsFromConfig::Adaptor';

    my $config = $app->config || {};

    foreach my $model_name ( grep { /^\Q$prefix\E/ } keys %$config ) {
        unless ($app->component($model_name)) {
            CatalystX::InjectComponent->inject(
                into => $app,
                component => $base_class,
                as => $model_name,
            );
        }
    }
}

1;
