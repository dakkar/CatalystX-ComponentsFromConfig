package CatalystX::ComponentsFromConfig::ViewAdaptor;
use Moose;

# ABSTRACT: trait-aware adaptor for Views

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
L<CatalystX::ComponentsFromConfig::Role::AdaptorRole>, adapts
arbitrary classes to Catalyst views, and can also apply roles to them
as specified in the configuration.

=cut

extends 'Catalyst::View';

with 'CatalystX::ComponentsFromConfig::Role::AdaptorRole'
    => { component_type => 'view' };

__PACKAGE__->meta->make_immutable;

1;
