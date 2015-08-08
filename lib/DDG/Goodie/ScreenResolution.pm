package DDG::Goodie::ScreenResolution;
# ABSTRACT: Return the current screen resolution using javascript

use DDG::Goodie;
use strict;

zci answer_type => "screen_resolution";
zci is_cached   => 1;

name "Screen Resolution";
description "Displays the current screen resolution using javascript";
primary_example_queries "screen resolution";
secondary_example_queries "what is my display resolution";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ScreenResolution.pm";
attribution twitter => 'mattr555',
            github => ['mattr555', 'Matt Ramina'];

triggers startend => "screen resolution", "display resolution", "resolution of my screen";

handle remainder => sub {
    return unless /^((what\'?s|what is)?\s?(the|my|current))?$/;

    return undef, structured_answer => {
        id => 'screen_resolution',
        name => 'Answer',
        data => {
            title => "Your screen resolution is [Loading...]"
        },
        templates => {
            group => 'icon',
            item => 0,
            options => {
                moreAt => 0
            }
        }
    };
};

1;
