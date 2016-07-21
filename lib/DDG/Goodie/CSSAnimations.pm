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

my $animations = LoadFile(share('content.yml'));

handle remainder => sub {
    print Dumper($animations);
    return 'CSS Animations',
        structured_answer => {
            id => 'cssanimations',
            name => 'CSS Animations',
            data => $animations,
            templates => {
                group => 'text',
                detail => 0,
                item_detail => 0,
                options => {
                    footer => 'DDH.cssanimations.footer'
                },
                variants => {
                    tileSnippet => 'large'
                }
            }
        };
};

1;
