package CatalystX::ModelsFromConfig::Adaptor;
use Moose;
use MooseX::Types::Moose qw/ HashRef ArrayRef Str /;
use MooseX::Types::LoadableClass qw/LoadableClass/;
use MooseX::Traits::Pluggable 0.10;
use namespace::autoclean;

extends 'Catalyst::Model';
with 'MooseX::Traits::Pluggable' => {
    -excludes => ['new_with_traits'],
    -alias => { _build_instance_with_traits => 'build_instance_with_traits' },
};

sub _trait_namespace {
    my ($self) = @_;
    my $class = $self->class;
    my $app_name = $self->app_name;
    if ($class =~ s/^\Q$app_name//) {
        my @list;
        do {
            push(@list, "${app_name}::TraitFor" . $class)
        }
        while ($class =~ s/::\w+$//);
        push(@list, "${app_name}::TraitFor::Model" . $class);
       return \@list;
    }
    return $class . '::TraitFor';
}

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

has args => (
    isa => HashRef,
    is => 'ro',
    default => sub { {} },
);

has traits => (
    isa => ArrayRef[Str],
    is => 'ro',
    default => sub { [] },
);

sub COMPONENT {
    my ($class, $app, @rest) = @_;
    my $self = $class->next::method($app, @rest);
    $self->app_name($app);

    $self->build_instance_with_traits(
        $self->class,
        {
            traits => $self->traits,
            %{ $self->args },
        },
    );
}

__PACKAGE__->meta->make_immutable;

1;
