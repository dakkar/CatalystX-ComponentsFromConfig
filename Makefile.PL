
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "create models / views at load time",
  "AUTHOR" => "Tomas Doran (t0m) <bobtfish\@bobtfish.net>, Gianni Ceccarelli <gianni.ceccarelli\@net-a-porter.com>",
  "BUILD_REQUIRES" => {
    "Catalyst" => 0,
    "Catalyst::Plugin::ConfigLoader" => 0,
    "Catalyst::Runtime" => "5.80",
    "Config::General" => 0,
    "Path::Class" => 0,
    "Test::Deep" => 0,
    "Test::More" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "CatalystX-ComponentsFromConfig",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "CatalystX::ComponentsFromConfig",
  "PREREQ_PM" => {
    "Catalyst::Model" => 0,
    "Catalyst::View" => 0,
    "CatalystX::InjectComponent" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::Role::Parameterized" => 0,
    "MooseX::Traits::Pluggable" => "0.10",
    "MooseX::Types::LoadableClass" => 0,
    "MooseX::Types::Moose" => 0,
    "namespace::autoclean" => 0
  },
  "VERSION" => "1.001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



