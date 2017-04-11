package DDG::Goodie::CssGradientGenerator;
# ABSTRACT: A CSS gradient generator

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'css_gradient_generator';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => 'css gradient generator', 'gradient generator', 'css gradient';

# Handle statement
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
