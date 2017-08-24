package DDG::Goodie::Nutritional;
# ABSTRACT: Food based nutritional information

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'nutritional';
zci is_cached => 1;

triggers any => 'nutrition';

handle query => sub {

    my $query = $_;

    return 'plain text response',
        structured_answer => {

            data => {
                title    => 'Nutritional',
                subtitle => 'The new nutritional IA',
            },
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.nutritional.content'
                }
            }
        };
};

1;
