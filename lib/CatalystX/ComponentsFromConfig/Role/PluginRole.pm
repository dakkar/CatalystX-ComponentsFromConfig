package CatalystX::ComponentsFromConfig::Role::PluginRole;
use MooseX::Role::Parameterized;
use CatalystX::InjectComponent;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

# ABSTRACT: parameterised role for plugins to create components from configuration

=head1 DESCRIPTION

Here we document implementation details, see
L<CatalystX::ComponentsFromConfig::Role::ModelPlugin> and
L<CatalystX::ComponentsFromConfig::Role::ViewPlugin> for usage
examples.

=head1 ROLE PARAMETERS

=head2 C<component_type>

One of C<'model'>, C<'view'>, C<'controller'>. There is no
pre-packaged plugin to create controllers, mostly because I could not
think of a sensible adaptor for them.

=cut

parameter component_type => (
    isa => enum(['model','view','controller']),
    required => 1,
);

=method C<setup_components>

C<after> the normal Catalyst components setup, call
C<_setup_dynamic_${component_type}>.

=method C<_setup_dynamic_${component_type}>

Loops through C<< $app->config >>, looking for sections that don't
correspond to existing components. For each one, uses
L<CatalystX::InjectComponent> to create the component, using as base
class either the one set globally in the C<<
${component_type}_from_config >> section, or the one set locally in
the C<base_class> value. If neither is set, the default C<<
CatalystX::ComponentsFromConfig::${component_type}Adaptor >> is used.

=cut

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

        my $prefix = "${uctype}::";

        my $base_class = $plugin_config->{base_class} ||
            "CatalystX::ComponentsFromConfig::${uctype}Adaptor";

        my $config = $app->config || {};

        foreach my $comp_name ( grep { /^\Q$prefix\E/ } keys %$config ) {
            unless ($app->component($comp_name)) {
                my $local_base_class =
                    $config->{$comp_name}{base_class} || $base_class;
                CatalystX::InjectComponent->inject(
                    into => $app,
                    component => $local_base_class,
                    as => $comp_name,
                );
            }
        }
    };
};

1;
