package DDG::Goodie::BirthStone;
# ABSTRACT: Returns the birthstone of the queried month

use DDG::Goodie;

triggers startend => 'birthstone', 'birth stone';

zci answer_type => "birth_stone";
zci is_cached   => 1;

primary_example_queries 'birthstone april';
secondary_example_queries 'may birth stone';
description 'returns the birth stone of the specified month';
name 'BirthStone';
topics 'special_interest', 'entertainment';
category 'random';
attribution github => ['https://github.com/austinheimark', 'Austin Heimark'];

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

    return $month . " birthstone: $stone",
      structured_answer => {
        input     => [$month],
        operation => 'Birthstone',
        result    => $stone
      };
};

1;
