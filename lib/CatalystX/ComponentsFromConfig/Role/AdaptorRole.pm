package CatalystX::ComponentsFromConfig::Role::AdaptorRole;
use MooseX::Role::Parameterized;
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/ HashRef ArrayRef Str /;
use MooseX::Types::Common::String qw/LowerCaseSimpleStr/;
use MooseX::Types::LoadableClass qw/LoadableClass/;
use MooseX::Traits::Pluggable 0.10;
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

    with 'MooseX::Traits::Pluggable' => {
        -excludes => ['new_with_traits'],
        -alias => { _build_instance_with_traits => 'build_instance_with_traits' },
    };


=method C<_trait_namespace>

Used by L<MooseX::Traits::Pluggable>. Given a L</class> of
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

    method _trait_namespace => sub {
        my ($self) = @_;
        my $class = $self->class;
        my $app_name = $self->app_name;
        if ($class =~ s/^\Q$app_name//) {
            my @list;
            do {
                push(@list, "${app_name}::TraitFor" . $class)
            } while ($class =~ s/::\w+$//);
            push(@list, "${app_name}::TraitFor::${type}" . $class);
            return \@list;
        }
        return $class . '::TraitFor';
    };

=attr C<class>

The name of the class to adapt.

=cut

    has class => (
        isa => LoadableClass,
        is => 'ro',
        required => 1,
        coerce => 1,
    );

    has app_name => (
        isa => 'Str',
        is => 'rw',
        init_arg => undef,
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

Arrayref of traits / roles to apply to the class we're adapting. These
will be processed by C<_build_instance_with_traits> in
L<MooseX::Traits::Pluggable> (like C<new_with_traits>, see also
L<MooseX::Traits>).

=cut

    has traits => (
        isa => ArrayRef[Str],
        is => 'ro',
        default => sub { [] },
    );

    around COMPONENT => sub {
        my ($orig, $class, $app, @rest) = @_;

        my $self = $class->$orig($app,@rest);
        $self->app_name($app);

        unless ($self->class->can('meta')) {
            Moose->init_meta(
                for_class => $self->class,
            );
        }

        $self->build_instance_with_traits(
            $self->class,
            {
                traits => $self->traits,
                %{ $self->args },
            },
        );
    };
};

1;
