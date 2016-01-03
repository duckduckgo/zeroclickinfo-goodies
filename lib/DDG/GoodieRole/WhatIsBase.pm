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

# This switch enables matching of forms such as 'How do I write X in Y?'.
has 'written' => (
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
my $how_forms = qr/(?:how (?:(?:do|would) (?:you|I))|to)/i;
my $spoken_forms = qr/(?:$how_forms say)/i;
my $written_forms = qr/(?:$how_forms write)/i;

# Matching for "What is X in Y", "How to say X in Y" etc...
sub _build_in_regexes {
    my $self = shift;
    my @ins = ($whatis_re);
    push @ins, $spoken_forms if $self->spoken;
    push @ins, $written_forms if $self->written;
    return qr/(?:@{[join '|', @ins]}) (?<to_translate>@{[$self->match_constraint]}) in @{[$self->to]}/i;
}

__PACKAGE__->meta->make_immutable();

1;
