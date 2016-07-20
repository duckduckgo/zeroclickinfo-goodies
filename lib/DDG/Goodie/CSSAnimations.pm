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
    
    return 'CSS Animations',
        structured_answer => {
            id => 'CSSAnimations',
            name => 'CSS Animations',
            data => {
                title    => 'CSS Animations',
                subtitle => 'My Subtitle'
            },
            templates => {
                group => 'text',
                variants => {
                    tileTitle => "3line-small",
                    tileFooter => "2line"
                },
                detail => false,
                item_detail => false
            }
        };
};

1;
