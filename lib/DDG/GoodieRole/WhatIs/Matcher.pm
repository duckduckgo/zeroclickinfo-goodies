package DDG::GoodieRole::WhatIs::Matcher;
# ABSTRACT: Object that generates matchers for various forms of query.

use strict;
use warnings;

use DDG::GoodieRole::WhatIs::Modifiers qw(get_modifiers);
use DDG::GoodieRole::WhatIs::Modifier;

use Moo;

# Hash from regular expressions to modifiers.
has '_modifier_regexes' => (
    is => 'ro',
    isa => sub { die "$_[0] is not a HASH reference" unless ref $_[0] eq 'HASH' },
    default => sub { {} },
);

# Determine which modifiers get applied to the matcher.
has 'groups' => (
    is => 'ro',
    isa => sub { die "$_[0] is not an ARRAY reference" unless ref $_[0] eq 'ARRAY' },
    default => sub { [] },
);

# Group-specific options.
has 'options' => (
    is => 'ro',
    isa => sub { die "$_[0] is not a HASH reference" unless ref $_[0] eq 'HASH' },
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
    foreach my $modifier (@modifiers) {
        $modifier->parse_options(%{$self->options});
        my $re = $modifier->generate_regex();
        $self->{_modifier_regexes}->{$re} = $modifier;
    };
}

sub _run_match {
    my ($to_match, $re, $modifier) = @_;
    if ($to_match =~ /$re/) {
        my %results = $modifier->build_result(%+);
        return \%results;
    }
    return;
}


1;
