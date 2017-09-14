package DDG::Goodie::CeramicCapacitorCodes;
# ABSTRACT: Decodes Ceramic Capacitor Codes into useful values

use strict;
use DDG::Goodie;
use Text::Trim;
use POSIX;
use utf8;

triggers startend =>
    'capacitor',
    'ceramic capacitor',
    'ceramic capacitors',
    'decode ceramic capacitor',
    'decode ceramic capacitors';

zci answer_type => "ceramic_capacitor_codes";
zci is_cached   => 1;

my %prefixes = (
    '0' => 'pF',
    '3' => 'nF',
    '6' => 'μF',
    '9' => 'mF'
);

my %tolerances = (
    'C' => '±0.25pF',
    'J' => '±5%',
    'K' => '±10%',
    'M' => '±20%',
    'D' => '±0.5pF',
    'Z' => '+80% / -20%'
);

handle remainder_lc => sub {
    
    return unless my ($digits, $multiplier, $tolerance) = /^([1-9][0-9])([0-9])([cjkmdz]?)$/;

    my $pico_farads = $digits * 10**$multiplier;
    my $order_of_magnitude = 1+$multiplier;
    $tolerance = uc $tolerance;
    my $engineering_order_of_magnitude = $order_of_magnitude - ($order_of_magnitude % 3);
    my $capacitance_in_engineering_units = $pico_farads / 10**$engineering_order_of_magnitude;

    my $unit = $prefixes{$engineering_order_of_magnitude};

    my $suffix = defined $tolerances{$tolerance} ? " ".$tolerances{$tolerance} : "";

    my $answer = "$capacitance_in_engineering_units $unit$suffix";
    return $answer,
        structured_answer => {
            data => {
                title    => $answer,
                subtitle => "Decode Ceramic Capacitor: ".uc($_)
            },
            templates => {
                group => 'text'
            }
    };
};

1;
