package CatalystX::ComponentsFromConfig::Role::AdaptorRole;
{
  $CatalystX::ComponentsFromConfig::Role::AdaptorRole::VERSION = '0.0.1';
}
{
  $CatalystX::ComponentsFromConfig::Role::AdaptorRole::DIST = 'CatalystX-ModelsFromConfig';
}
use MooseX::Role::Parameterized;
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/ HashRef ArrayRef Str /;
use MooseX::Types::LoadableClass qw/LoadableClass/;
use MooseX::Traits::Pluggable 0.10;
use namespace::autoclean;

# ABSTRACT: parameterised role for trait-aware component adaptors

parameter component_type => (
    isa => enum(['model','view','controller']),
    required => 1,
);

role {
    my $params = shift;
    my $type = ucfirst($params->component_type);

    with 'MooseX::Traits::Pluggable' => {
        -excludes => ['new_with_traits'],
        -alias => { _build_instance_with_traits => 'build_instance_with_traits' },
    };

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

    method SUBCOMPONENT => sub {
        my ($self, $app, @rest) = @_;
        $self->app_name($app);

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

__END__
=pod

=encoding utf-8

=head1 NAME

CatalystX::ComponentsFromConfig::Role::AdaptorRole - parameterised role for trait-aware component adaptors

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

