package DDG::GoodieRole::WhatIs::Base;
# ABSTRACT: Object that generates matchers for various forms of query.

use strict;
use warnings;

use DDG::GoodieRole::WhatIs::Modifiers qw(get_modifiers);
use DDG::GoodieRole::WhatIs::Modifier;

use Moose;

# Hash from regular expressions to modifiers.
has '_modifier_regexes' => (
    is => 'ro',
    isa => 'HashRef[Regexp]',
    default => sub { {} },
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
    foreach my $re (keys %{$self->_modifier_regexes}) {
         if (my $res = _run_match($to_match, qr/$re/)) {
             return $res;
         }
    }
    return;
}

sub full_match {
    my ($self, $to_match) = @_;
    my %reg_map = %{$self->_modifier_regexes};
    while (my ($re, $modifier) = each %reg_map) {
         if (my $res = _run_match($to_match, qr/^$re$/, $modifier)) {
             return $res;
         };
    };
    return;
}

sub BUILD {
    my $self = shift;
    my @modifiers = get_modifiers($self->groups);
    die "Could not assign any modifiers based on groups: [@{[join ', ', @{$self->groups}]}]\n"
        unless @modifiers;
    foreach my $modifier (@modifiers) {
        $modifier->parse_options($self->options);
        my $re = $modifier->generate_regex();
        $self->{_modifier_regexes}->{$re} = $modifier;
    };
}

__PACKAGE__->meta->make_immutable();

sub _run_match {
    my ($to_match, $re, $modifier) = @_;
    if ($to_match =~ /$re/) {
        my %results = $modifier->build_result(%+);
        return \%results;
    }
    return;
}


1;
