package DDG::Goodie::CSSAnimations;
# ABSTRACT: Shows examples of CSS Animations from various references

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'cssanimations';

zci is_cached => 1;

triggers start => 'css animations', 'css animations example', 'css animation', 'css animation examples', 
                  'css animation demo', 'css animations demos', 'css animations demos', 'css animation demos';

handle remainder => sub {

    my $remainder = $_;

    return 'CSS Animations',
        structured_answer => {
            data => {
                title    => '',
                subtitle => 'My Subtitle'
            },

            templates => {
                group => 'text',
                # options => {
                #
                # }
            }
        };
};

1;
