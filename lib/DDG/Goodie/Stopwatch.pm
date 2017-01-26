package DDG::Goodie::Stopwatch;
# ABSTRACT: Shows a stopwatch

use DDG::Goodie;
use strict;

zci answer_type => 'stopwatch';
zci is_cached => 1;

triggers startend => 'stopwatch', 'stop watch', 'chronometer', 'chronograph';

# Handle statement
handle remainder => sub {
    return unless ($_ eq '' || $_ eq 'online');

    return "",
        structured_answer => {
            templates => {
                group => 'base',
                detail => 'DDH.stopwatch.stopwatch',
                wrap_detail => 'base_detail'
            },
            meta => {
                sourceName => "Stopwatch",
                itemType => "stopwatch"
            },
            data => {}
        };
};

1;
