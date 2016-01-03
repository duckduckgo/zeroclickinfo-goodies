package DDG::GoodieRole::WhatIsBase;
# ABSTRACT: Object that represents certain types of 'what is...' queries.

use strict;
use warnings;

use Moose;

has 'to' => (
    is  => 'ro',
    isa => 'Str',
);

has '_match_regex' => (
    is  => 'ro',
    isa => 'Regexp',
);

# What text should actually match to be translated.
# The 'X' in 'What is X in Y'.
has 'match_constraint' => (
    is => 'ro',
    isa => 'Regexp',
    default => sub { qr/.+/ },
);

# This switch enables matching of forms such as 'How do I say X in Y?'.
has 'spoken' => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

sub match {
    my ($self, $to_match) = @_;
    $to_match =~ $self->_match_regex or return;
    return {
        value => $+{'to_translate'},
    };
}

my $whatis_re = qr/what is/i;

sub _build_regex {
    my $self = shift;
    my $prefix_forms = $whatis_re;
    return $self->_build_in_regexes();
}

sub BUILD {
    my $self = shift;
    $self->{'_match_regex'} = $self->_build_regex;
}

# Various ways of saying "How would I say";
my $additional_forms = qr/(?:what is|how (?:(?:do|would) (?:you|I)| to) say)/i;
my $spoken_forms = qr/(?:how (?:(?:do|would) (?:you|I)|to) say)/i;

# Matching for "What is X in Y", "How to say X in Y" etc...
sub _build_in_regexes {
    my $self = shift;
    my @ins = ($whatis_re);
    push @ins, $spoken_forms if $self->spoken;
    return qr/(?:@{[join '|', @ins]}) (?<to_translate>@{[$self->match_constraint]}) in @{[$self->to]}/i;
}

sub _to_regexes {
    my $name = shift;
    return qr/(?:$additional_forms (?<to_translate>.+) (?<action>in) $name|translate (?<to_translate>.+) (?<action>to) $name)/i;
}

__PACKAGE__->meta->make_immutable();

1;
