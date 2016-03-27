package DDG::Goodie::Countdown;

# ABSTRACT: Provides a countdown to a particular date or time

use DDG::Goodie;
use strict;

zci answer_type => 'countdown';

zci is_cached => 1;

triggers any => 'countdown to';

# Handle statement
handle remainder => sub {

    return "",
        structured_answer => {

            id => 'countdown',

            name => 'Answer',

            data => {
                remainder => $_
            },

            templates => {
                group => "text",
            }
        };
};

1;
