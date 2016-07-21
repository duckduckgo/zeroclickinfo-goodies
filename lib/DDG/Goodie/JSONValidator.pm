package DDG::Goodie::JSONValidator;
# ABSTRACT: An Interactive JSON Validation Tool

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'jsonvalidator';

zci is_cached => 1;

triggers any => 'json validation', 'json validator';

handle remainder => sub {

    my $remainder = $_;

    return '',
        structured_answer => {

            id => "json_validator",

            data => {
                title => 'JSON Validator',
                subtitle => 'Enter your JSON below and click on the button to check if it\'s valid'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.json_validator.content'
                }
            }
        };
};

1;
