package DDG::Goodie::Weight;
# ABSTRACT: Calculate the weight of provided mass.

use strict;
use DDG::Goodie;
use Scalar::Util qw(looks_like_number);
use Text::Trim;

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

# Value of acceleration due to gravity on Earth in m/s^2.
use constant g => 9.80665;

# Handle statement
handle query_lc => sub {

    return unless m/^(what is the )?(earth )?weight (on earth )?(of )?(a )?(?<mass>\d+(\.\d+)?) ?(?<unit>\w+)( mass)?( on)?( earth)?\??$/;
    my $mass_input = $+{mass};
    my $default_unit = "kg";
    my $unit = $+{unit} // $default_unit;

    my $mass = $mass_input;

    if ($unit){
        return unless exists $units{$unit};
        $mass *= $units{$unit};
    }

    # Weight = Mass (in kg) * Acceleration due to gravity (in m/s^2)
    my $weight = $mass*g;

    # Text to be shown to indicate conversion done
    my $conversiontext = "($mass kg) ";

    if ( $unit eq "kg" || $unit eq "kgs" ) {
        $conversiontext = "";
    }

    my $massUnit = $mass_input.$unit;

    return "Weight of a $massUnit mass on Earth is ${weight}N",
        structured_answer => {
            data => {
                title    => "Weight of a $massUnit ${conversiontext}mass on Earth is ${weight}N",
                subtitle => "Taking value of acceleration due to gravity on Earth as ".g."m/s^2"
            },
            templates => {
                group => "text"
            }
        };
};

1;
