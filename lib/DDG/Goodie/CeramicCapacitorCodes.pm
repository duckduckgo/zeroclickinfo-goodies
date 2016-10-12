package DDG::Goodie::CeramicCapacitorCodes;
# ABSTRACT: Decodes Ceramic Capacitor Codes into useful values

use strict;
use DDG::Goodie;
use Text::Trim;

triggers startend =>
    'ceramic capacitor',
    'ceramic capacitors',
    'decode ceramic capacitor',
    'decode ceramic capacitors';

zci answer_type => "ceramic_capacitor_codes";
zci is_cached   => 1;

handle remainder_lc => sub {
    
    return unless my ($digits, $multiplier, $tolerance) = /^([0-9]{2})([0-9])([cjkmdz]?)$/;

    my $pico_farads = $digits * 10**$multiplier;
    my $answer = "$pico_farads pF";
    return $answer,
        structured_answer => {
            data => {
                title    => "$pico_farads",
                subtitle => "$pico_farads"
            },
            templates => {
                group => 'text'
            }
    };
};

1;
