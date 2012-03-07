package CatalystX::ComponentsFromConfig;

# ABSTRACT: create models / views at load time

=head1 SYNOPSYS

In your application:

  use Catalyst qw(
      ConfigLoader
      +CatalystX::ComponentsFromConfig::ModelPlugin
  );

In your configuration:

  <Model::MyClass>
   class My::Class
   <args>
    some param
   </args>
  </Model::MyClass>

Now, C<< $c->model('MyClass') >> will contain an object built just like:

  My::Class->new({some=>'param'});

=head1 DESCRIPTION

This distribution provides 2 Catalyst plugins
(L<CatalystX::ComponentsFromConfig::ModelPlugin> and
L<CatalystX::ComponentsFromConfig::ViewPlugin>) and 2 adaptor classes
(L<CatalystX::ComponentsFromConfig::ModelAdaptor> and
L<CatalystX::ComponentsFromConfig::ViewAdaptor>).

=cut

1;
