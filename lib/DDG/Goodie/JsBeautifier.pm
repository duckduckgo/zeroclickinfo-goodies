package DDG::Goodie::JsBeautifier;
# ABSTRACT: Write an abstract here

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'jsbeautifier';
zci is_cached => 1;

triggers startend => share('triggers.txt')->slurp;

handle remainder => sub {

    # Return unless the remainder is empty or contains online or tool
    return unless ( $_ =~ /(^$|online|tool|code|utility)/i );

    return '',
        structured_answer => {

            id => "js_beautifier",

            data => {
                title => 'JavaScript Beautifier',
                subtitle => 'Enter code below, then click the button to beautify'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.js_beautifier.content'
                }
            }
        };
};

1;