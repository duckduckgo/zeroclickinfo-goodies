package DDG::Goodie::RGBColor;

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'rgb_color';

zci is_cached => 1;

triggers any => 'triggerword', 'trigger phrase';

handle query_lc => sub {

    my $query_lc = $_;

    return "plain text response",
        structured_answer => {

            data => {
                title    => "My Instant Answer Title",
                subtitle => "My Subtitle",
            },

            templates => {
                group => "text",
            }
        };
};

1;
