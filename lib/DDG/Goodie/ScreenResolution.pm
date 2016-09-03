package DDG::Goodie::ScreenResolution;
# ABSTRACT: Return the current screen resolution using javascript

use DDG::Goodie;
use strict;

zci answer_type => "screen_resolution";
zci is_cached   => 1;

triggers startend => "screen resolution", "display resolution", "resolution of my screen";

handle remainder => sub {
    return unless /^((what\'?s|what is)?\s?(the|my|current))?$/;

    return undef, structured_answer => {
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
