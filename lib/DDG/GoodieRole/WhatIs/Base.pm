package DDG::GoodieRole::WhatIs::Base;
# ABSTRACT: Object that generates matchers for various forms of query.

use strict;
use warnings;

use DDG::GoodieRole::WhatIs::Modifiers qw(get_modifiers);
use DDG::GoodieRole::WhatIs::Modifier;

use Moose;

has '_match_regex' => (
    is  => 'ro',
    isa => 'Regexp',
);

has '_regex_forms' => (
    is => 'ro',
    isa => 'ArrayRef[Regexp]',
    default => sub { [] },
);

# Determine which modifiers get applied to the matcher.
has 'groups' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
);

# Group-specific options.
has 'options' => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { {} },
);

sub match {
    my ($self, $to_match) = @_;
    $to_match =~ $self->_match_regex or return;
    return {
        value => $+{'to_translate'},
    };
}


sub _build_regex {
    my $self = shift;
    my @forms = @{$self->_regex_forms};
    return qr/@{[join '|', @forms]}/;
}

sub BUILD {
    my $self = shift;
    my @modifiers = get_modifiers($self->groups);
    foreach my $modifier (@modifiers) {
        $modifier->parse_options($self->options);
        $modifier->run_action($self);
    };
    $self->{'_match_regex'} = $self->_build_regex;
}

# Another entire matching possibility.
sub _add_re {
    my ($self, $re) = @_;
    push @{$self->_regex_forms}, $re;
}

__PACKAGE__->meta->make_immutable();

1;
