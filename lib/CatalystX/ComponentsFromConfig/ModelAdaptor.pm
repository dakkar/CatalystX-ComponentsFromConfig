package CatalystX::ComponentsFromConfig::ModelAdaptor;
use Moose;

# ABSTRACT: trait-aware adaptor for Models

=head1 SYNOPSIS

In your application:

  package My::App;
  use Catalyst qw(
      ConfigLoader
      +CatalystX::ComponentsFromConfig::ModelPlugin
  );

In your config:

   <Model::MyClass>
    class My::Class
    <args>
      some  param
    </args>
    <traits>
      +My::Special::Role
    </traits>
   </Model::MyClass>

Now, C<< $c->model('MyClass') >> will contain an object built just like:

  my $obj = My::Class->new({some=>'param'});
  apply_all_roles($obj,'My::Special::Role');

=head1 DESCRIPTION

This plugin, built on
L<CatalystX::ComponentsFromConfig::Role::AdaptorRole>, adapts
arbitrary classes to Catalyst models, and can also apply roles to them
as specified in the configuration.

=cut

extends 'Catalyst::Model';

with 'CatalystX::ComponentsFromConfig::Role::AdaptorRole'
    => { component_type => 'model' };

__PACKAGE__->meta->make_immutable;

1;
