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

sub match {
    my ($self, $to_match) = @_;
    $to_match =~ $self->_match_regex ? 1 : 0;
}

my $whatis_re = qr/what is/i;

sub _build_regex {
    my $self = shift;
    my $prefix_forms = $whatis_re;
    return qr/$prefix_forms .+ in @{[$self->to]}/i;
}

sub BUILD {
    my $self = shift;
    $self->{'_match_regex'} = $self->_build_regex;
}

# Various ways of saying "How would I say";
my $additional_forms = qr/(?:what is|how (?:(?:do|would) (?:you|I)| to) say)/i;

sub _to_regexes {
    my $name = shift;
    return qr/(?:$additional_forms (?<to_translate>.+) (?<action>in) $name|translate (?<to_translate>.+) (?<action>to) $name)/i;
}

__PACKAGE__->meta->make_immutable();

1;
