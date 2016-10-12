package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

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

    $pico_farads = $digits * 10**$multiplier;

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
