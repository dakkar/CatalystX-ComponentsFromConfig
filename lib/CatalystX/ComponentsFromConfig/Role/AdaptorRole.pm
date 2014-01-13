package CatalystX::ComponentsFromConfig::Role::AdaptorRole;
use MooseX::Role::Parameterized;
use Moose::Util::TypeConstraints;
use Moose::Util 'with_traits';
use MooseX::Types::Moose qw/ HashRef ArrayRef Str /;
use MooseX::Types::Common::String qw/LowerCaseSimpleStr/;
use MooseX::Types::LoadableClass qw/LoadableClass/;
use Sub::Install;
use namespace::autoclean;

# ABSTRACT: parameterised role for trait-aware component adaptors

=head1 DESCRIPTION

Here we document implementation details, see
L<CatalystX::ComponentsFromConfig::ModelAdaptor> and
L<CatalystX::ComponentsFromConfig::ViewAdaptor> for usage examples.

This role uses L<MooseX::Traits::Pluggable> to allow you to add roles
to your model classes via the configuration.

=head1 ROLE PARAMETERS

=head2 C<component_type>

The type of component to create, in lower case. Usually one of
C<'model'>, C<'view'> or C<'controller'>. There is no pre-packaged
adptor to create controllers, mostly because I could not think of a
sensible way to write it.

=cut

parameter component_type => (
    isa => LowerCaseSimpleStr,
    required => 1,
);

role {
    my $params = shift;
    my $type = ucfirst($params->component_type);

=attr C<class>

The name of the class to adapt.

=cut

    has class => (
        isa => LoadableClass,
        is => 'ro',
        required => 1,
        coerce => 1,
    );

=attr C<args>

Hashref to pass to the constructor of the adapted class.

=cut

    has args => (
        isa => HashRef,
        is => 'ro',
        default => sub { {} },
    );

=attr C<traits>

Arrayref of traits / roles to apply to the class we're adapting.

If set, and the L</class> has a C<new_with_traits> constructor, it
will be called with L</args> augmented by C<< traits => $traits >>. If
L</class> does not have that constructor, a subclass will be created
by applying L<MooseX::Traits::Pluggable> to L</class>, to get the
C<new_with_traits> constructor.

If L</class> provides C<new_with_traits>, that constructor is expected
to deal with converting whatever is in C<traits> into actual module
names. If, instead, we have to inject L<MooseX::Traits::Pluggable>, we
depend on its own name expansion, but we provide our own set of
namspaces: given a L</class> of
C<My::App::Special::Class::For::Things> loaded into the C<My::App>
Catalyst application, the following namespaces will be searched for
traits / roles:

=for :list
* C<My::App::TraitFor::Special::Class::For::Things>
* C<My::App::TraitFor::Class::For::Things>
* C<My::App::TraitFor::For::Things>
* C<My::App::TraitFor::Things>
* C<My::App::TraitFor::${component_type}::Things>

On the other hand, if the class name does not start with the
application name, just C<${class}::TraitFor> will be searched.

=cut

    has traits => (
        isa => ArrayRef[Str],
        is => 'ro',
    );

    around COMPONENT => sub {
        my ($orig, $class, $app, @rest) = @_;

        my $self = $class->$orig($app,@rest);
        my $other_class = $self->class;

        unless ($other_class->can('meta')) {
            Moose->init_meta(
                for_class => $other_class,
            );
        }

        if ($self->traits) {
            if (not $other_class->can('new_with_traits')) {
                my $new_class = with_traits(
                    $other_class,
                    'MooseX::Traits::Pluggable',
                );

                Sub::Install::install_sub({
                    code => sub {
                        my ($other_self) = @_;
                        if ($other_class =~ s/^\Q$app//) {
                            my @list;
                            do {
                                push(@list, "${app}::TraitFor" . $other_class)
                            } while ($other_class =~ s/::\w+$//);
                            push(@list, "${app}::TraitFor::${type}" . $other_class);
                            return \@list;
                        }
                        return $other_class . '::TraitFor';
                    },
                    into => $new_class,
                    as => '_trait_namespace',
                });
                $other_class = $new_class;
            }
            return $other_class->new_with_traits({
                traits => $self->traits,
                %{ $self->args },
            });
        }
        return $other_class->new($self->args);
    };
};

1;
