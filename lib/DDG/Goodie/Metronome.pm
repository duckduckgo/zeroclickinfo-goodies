package DDG::Goodie::Metronome;
# ABSTRACT:  Shows a metronome

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'metronome';
zci is_cached => 1;

triggers startend => 'metronome';

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
                title => 'Metronome'
            },
            templates => {
                group       => 'base',
                detail      => 'DDH.metronome.metronome'
            }
        };
};

1;
