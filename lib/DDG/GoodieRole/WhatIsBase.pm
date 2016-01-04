package DDG::GoodieRole::WhatIsBase;
# ABSTRACT: Object that generates matchers for various forms of query.

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

has 'groups' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
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
    my @forms = get_forms($self->groups);
    return qr/@{[join '|', map { $_->($self) } @forms]}/;
}

sub BUILD {
    my $self = shift;
    $self->{'_match_regex'} = $self->_build_regex;
}

# Various ways of saying "How would I say";
my $how_forms = qr/(?:how (?:(?:do|would) (?:you|I))|to)/i;
my $spoken_forms = qr/(?:$how_forms say)/i;
my $written_forms = qr/(?:$how_forms write)/i;

sub _in_re {
    my ($self, $re) = @_;
    return qr/$re (?<to_translate>@{[$self->match_constraint]}) in @{[$self->to]}/i;
}

sub _written_forms { _in_re($_[0], $written_forms); }
sub _spoken_forms { _in_re($_[0], $spoken_forms); }
sub _what_is_re { _in_re($_[0], qr/what is/i); }


__PACKAGE__->meta->make_immutable();

use List::MoreUtils qw(all any uniq);

my %match_forms = (
    'written' => {
        groups => [['translation', 'written']],
        action => \&_written_forms,
    },
    'spoken' => {
        groups => [['spoken', 'translation']],
        action => \&_spoken_forms,
    },
    'whatis' => {
        groups => [],
        action => \&_what_is_re,
    },
);

# The unique elements of $child is a sublist of the unique elements of
# $container?
sub sublist_uniques {
    my ($child, $container) = @_;
    my @uniques = uniq @$container;
    return all { my $c = $_; any { $_ eq $c } @uniques } (uniq @$child);
}

sub get_forms {
    my $groups = shift;
    my @forms = ();
    return unless @$groups;
    while (my ($match_type, $options) = each %match_forms) {
        my $required_groups = $options->{'groups'};
        foreach my $req_group (@$required_groups) {
            if (sublist_uniques($req_group, $groups)) {
                push @forms, $options->{'action'};
                last;
            };
        };
        push @forms, $options->{'action'} unless @$required_groups;
    };
    return @forms;
}

1;
