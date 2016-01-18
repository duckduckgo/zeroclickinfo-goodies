package DDG::Goodie::BirthStone;
# ABSTRACT: Returns the birthstone of the queried month

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';

triggers startend => 'birthstone', 'birth stone';

zci answer_type => "birth_stone";
zci is_cached   => 1;

my %birthstones = (
    "January"   => "Garnet",
    "February"  => "Amethyst",
    "March"     => "Aquamarine",
    "April"     => "Diamond",
    "May"       => "Emerald",
    "June"      => "Pearl",
    "July"      => "Ruby",
    "August"    => "Peridot",
    "September" => "Sapphire",
    "October"   => "Opal",
    "November"  => "Topaz",
    "December"  => "Turquoise"
);

my $matcher = wi_custom({
    groups => ['imperative', 'prefix', 'postfix'],
    options => {
        command => qr/birth ?stone/i,
        primary => qr/@{[join '|', keys %birthstones]}/i,
    },
});

handle query_raw => sub {
    my $query = shift;
    my $match = $matcher->full_match($query) or return;
    my $month = ucfirst lc $match->{primary};

    return unless $month;
    my $stone = $birthstones{$month};
    return unless $stone;

    return $month . " birthstone: $stone",
      structured_answer => {
        input     => [$month],
        operation => 'Birthstone',
        result    => $stone
      };
};

1;
