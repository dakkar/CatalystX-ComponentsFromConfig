package CatalystX::ComponentsFromConfig::ViewPlugin;
use Moose::Role;

# ABSTRACT: plugin to create Views from configuration

=head1 SYNOPSIS

In your application:

  package My::App;
  use Catalyst qw(
      ConfigLoader
      +CatalystX::ComponentsFromConfig::ViewPlugin
  );

In your config:

   <View::MyClass>
    class My::Class
    <args>
      some  param
    </args>
    <traits>
      +My::Special::Role
    </traits>
   </View::MyClass>

Now, C<< $c->view('MyClass') >> will contain an object built just like:

  my $obj = My::Class->new({some=>'param'});
  apply_all_roles($obj,'My::Special::Role');

=head1 DESCRIPTION

This plugin, built on
L<CatalystX::ComponentsFromConfig::Role::PluginRole>, allows you to
create view components at application setup time, just by specifying
them in the configuration.

=head1 GLOBAL CONFIGURATION

  <views_from_config>
   base_class My::ViewAdaptor
  </views_from_config>

The default C<base_class> is
C<CatalystX::ComponentsFromConfig::ViewAdaptor>, buty you can specify
whatever adaptor you want. Of course, you have to make sure that the
view-specific configuration block is in the format that your adaptor
expects.

=cut

with 'CatalystX::ComponentsFromConfig::Role::PluginRole'
    => { component_type => 'view' };

1;
