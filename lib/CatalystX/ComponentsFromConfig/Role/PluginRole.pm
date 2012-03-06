package CatalystX::ComponentsFromConfig::Role::PluginRole;
{
  $CatalystX::ComponentsFromConfig::Role::PluginRole::VERSION = '0.0.1';
}
{
  $CatalystX::ComponentsFromConfig::Role::PluginRole::DIST = 'CatalystX-ModelsFromConfig';
}
use MooseX::Role::Parameterized;
use CatalystX::InjectComponent;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

# ABSTRACT: parameterised role for plugins to create components from configuration

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

__END__
=pod

=encoding utf-8

=head1 NAME

CatalystX::ComponentsFromConfig::Role::PluginRole - parameterised role for plugins to create components from configuration

=head1 VERSION

version 0.0.1

=head1 AUTHORS

=over 4

=item *

Tomas Doran (t0m) <bobtfish@bobtfish.net>

=item *

Gianni Ceccarelli <gianni.ceccarelli@net-a-porter.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Net-a-porter.com.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

