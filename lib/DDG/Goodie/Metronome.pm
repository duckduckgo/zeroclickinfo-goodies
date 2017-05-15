package DDG::Goodie::Metronome;
# ABSTRACT: Write an abstract here

# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'metronome';

# Caching - https://duck.co/duckduckhack/spice_advanced_backend#caching-api-responses
zci is_cached => 1;

# Triggers - https://duck.co/duckduckhack/goodie_triggers
triggers startend => 'metronome';

# Handle statement
handle remainder => sub {

    return '',
        structured_answer => {
            id     =>  'metronome',
            name   => 'Metronome',
            signal => 'high',
            meta => {
                sourceName => 'Metronome',
                itemType   => 'metronome'
            },
            data => {
                remainder => $_
            },
            templates => {
                group       => 'base',
                detail      => 'DDH.metronome.metronome'
            }
        };
};

1;
