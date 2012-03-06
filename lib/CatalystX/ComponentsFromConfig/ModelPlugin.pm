package CatalystX::ComponentsFromConfig::ModelPlugin;
{
  $CatalystX::ComponentsFromConfig::ModelPlugin::VERSION = '0.0.1';
}
{
  $CatalystX::ComponentsFromConfig::ModelPlugin::DIST = 'CatalystX-ComponentsFromConfig';
}
use Moose::Role;

# ABSTRACT: plugin to create Models from configuration

with 'CatalystX::ComponentsFromConfig::Role::PluginRole'
    => { component_type => 'model' };

1;

__END__
=pod

=encoding utf-8

=head1 NAME

CatalystX::ComponentsFromConfig::ModelPlugin - plugin to create Models from configuration

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

