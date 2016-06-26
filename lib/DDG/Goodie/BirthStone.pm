package DDG::Goodie::BirthStone;
# ABSTRACT: Returns the birthstone of the queried month

use strict;
use DDG::Goodie;

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

handle remainder => sub {
    my $month = ucfirst lc $_;

    return unless $month;
    my $stone = $birthstones{$month};
    return unless $stone;

    return "$month birthstone: $stone",
        structured_answer => {
            data => {
                title    => $stone,
                subtitle => "Birthstone for $month",
            },
            templates => {
                group => 'text',
            }
        }
};

1;
