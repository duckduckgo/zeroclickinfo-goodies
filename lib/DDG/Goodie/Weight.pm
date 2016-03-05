package DDG::Goodie::Weight;
# ABSTRACT: Calculate the weight of provided mass.

use strict;
use DDG::Goodie;
use Scalar::Util qw(looks_like_number);
use Text::Trim;
with 'DDG::GoodieRole::WhatIs';

zci answer_type => "weight";
zci is_cached   => 1;

# Triggers
triggers any => "weight";

my %units = (
    "kg" => 1,
    "kgs" => 1,
    "g"  => 0.001,
    "gs"  => 0.001,
    "mg" => 0.00001,
    "mgs" => 0.00001,
    "t" => 1000,
    "ts" => 1000,
    "lb" => 0.453,
    "lbs" => 0.453,
    "oz" => 0.0283,
    "ozs" => 0.0283,
);

my $unit_re = qr/(?:@{[join '|', (keys %units)]})/i;

my $matcher = wi_custom(
    groups => ['property', 'command'],
    options => {
        property => qr/(earth weight|weight( on earth)?)/i,
        command => qr/weight/i,
        primary => qr/(a )?(?<mass>\d+(\.\d+)?) ?(?<unit>$unit_re)( mass)?( on)?( earth)?\??$/i,
    },
);

# Value of acceleration due to gravity on Earth in m/s^2.
use constant g => 9.80665;

# Handle statement
handle query_lc => sub {
    my $query = shift;
    my $match = $matcher->full_match($query) or return;

    my $mass_input = $match->{mass};
    my $unit = lc ($match->{unit} // 'kg');
    my $mass = $mass_input * $units{$unit};

    # Weight = Mass (in kg) * Acceleration due to gravity (in m/s^2)
    my $weight = $mass*g;

    # Text to be shown to indicate conversion done
    my $conversiontext = "($mass kg) ";

    if ( $unit eq "kg" || $unit eq "kgs" ) {
        $conversiontext = "";
    }

    my $massUnit = $mass_input.$unit;

    return "Weight of a ".$massUnit." mass on Earth is ".$weight."N.",
        structured_answer => {
            input     => [],
            operation => "Taking value of acceleration due to gravity on Earth as ".g."m/s^2.",
            result    => "Weight of a ".$massUnit." ".$conversiontext."mass on Earth is ".$weight."N.",
        };


};

1;
