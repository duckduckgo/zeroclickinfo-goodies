package DDG::Goodie::CSSAnimations;
# ABSTRACT: Shows examples of CSS Animations from various references

use DDG::Goodie;
use YAML::XS 'LoadFile';
use Data::Dumper;
use strict;
use warnings;

zci answer_type => 'cssanimations';

zci is_cached => 1;

triggers start => 'css animations', 'css animations example', 'css animation', 'css animation examples', 
                  'css animation demo', 'css animations demos', 'css animations demos', 'css animation demos';
                  
my $animations = LoadFile(share('css-animations.yml'));

handle remainder => sub {
    print Dumper($animations);
    return 'CSS Animations',
        structured_answer => {
            id => 'CSSAnimations',
            name => 'CSS Animations',
            data => $animations,
            templates => {
                group => 'icon',
                detail => false,
                item_detail => false
            }
        };
};

1;
