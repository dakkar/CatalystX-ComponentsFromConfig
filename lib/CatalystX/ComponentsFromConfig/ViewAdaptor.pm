package CatalystX::ComponentsFromConfig::ViewAdaptor;
{
  $CatalystX::ComponentsFromConfig::ViewAdaptor::VERSION = '0.0.1';
}
{
  $CatalystX::ComponentsFromConfig::ViewAdaptor::DIST = 'CatalystX-ComponentsFromConfig';
}
use Moose;

# ABSTRACT: trait-aware adaptor for Views

extends 'Catalyst::View';

with 'CatalystX::ComponentsFromConfig::Role::AdaptorRole'
    => { component_type => 'view' };

# I'm not sure why this is needed, but if I put COMPONENT in the
# AdaptorRole, things break
sub COMPONENT {
    my ($class, $app, @rest) = @_;
    my $self = $class->next::method($app, @rest);
    return $self->SUBCOMPONENT($app,@rest);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=encoding utf-8

=head1 NAME

CatalystX::ComponentsFromConfig::ViewAdaptor - trait-aware adaptor for Views

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

