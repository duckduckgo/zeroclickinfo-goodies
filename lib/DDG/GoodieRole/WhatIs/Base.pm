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

sub _run_matches {
    my ($re_sub, $self, $to_match) = @_;
    my %reg_map = %{$self->_modifier_regexes};
    my @sorted_re = sort {
        $reg_map{$b}->priority <=> $reg_map{$a}->priority
    } (keys %reg_map);
    foreach my $re (@sorted_re) {
        my $modifier = $reg_map{$re};
        if (my $res = _run_match($to_match, $re_sub->($re), $modifier)) {
            return $res;
        };
    }
    return;
}

sub match { _run_matches(sub { $_[0] }, @_) };

sub full_match { _run_matches(sub { qr/^$_[0]$/ }, @_) }

sub BUILD {
    my $self = shift;
    my @modifiers = get_modifiers($self->groups);
    die "Could not assign any modifiers based on groups: [@{[join ', ', @{$self->groups}]}]\n"
        unless @modifiers;
    foreach my $modifier (@modifiers) {
        $modifier->parse_options(%{$self->options});
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
