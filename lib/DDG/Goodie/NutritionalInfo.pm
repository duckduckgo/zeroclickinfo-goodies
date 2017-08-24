package DDG::Goodie::NutritionalInfo;
# ABSTRACT: Supplies nutritional info

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'nutritional_info';
zci is_cached => 1;
triggers any => 'nutrition';

# Handle statement
handle query => sub {
    my $query = $_;

    return 'plain text response',
        structured_answer => {

            data => {
                title    => 'Nutrition',
                subtitle => 'The new nutrition IA',
            },
            templates => {
                group => 'text',
            }
        };
};

1;
