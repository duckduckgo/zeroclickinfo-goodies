package DDG::Goodie::CssColors;
# ABSTRACT: List of all the named CSS colors

use DDG::Goodie;

use strict;
use warnings;

zci answer_type => 'csscolors';

zci is_cached => 1;

triggers any => 'css colors', 'css3 colors', 'css named colors', 'css3 named colors', 'named css colors', 'named css3 colors', 'css colours', 'css3 colours', 'css named colours', 'css3 named colours', 'named css colours', 'named css3 colours';

handle query_lc => sub {

    my $query_lc = $_;

    return 'CSS Colors',
        structured_answer => {

            data => {
                title    => 'CSS Colors',
                list => ''
            },

            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.csscolors.list_content'
                }
            }
        };
};

1;
