package DDG::Goodie::CssGradientGenerator;
# ABSTRACT: A CSS gradient generator

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'css_gradient_generator';

zci is_cached => 1;

triggers any => 'css gradient generator', 'gradient generator', 'gradient css generator';

handle remainder => sub {

    my $remainder = $_;

    return 'CSS Gradient Generator',
        structured_answer => {

            data => {

            },

            templates => {
                group => 'text',
                options => {
                    content => "DDH.css_gradient_generator.content"
                }
            }
        };
};

1;
