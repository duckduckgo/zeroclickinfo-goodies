package DDG::Goodie::JsMinify;
# ABSTRACT: An Interactive JavaScript Minifier Tool

use DDG::Goodie;
use strict;

zci answer_type => 'jsminify';
zci is_cached => 1;

triggers startend => share('triggers.txt')->slurp;

handle remainder => sub {

    # Return unless the remainder is empty or contains online or tool
    return unless ( $_ =~ /(^$|online|tool)/i );

    return '',
        structured_answer => {

            id => "js_minify",

            data => {
                title => 'Minifier',
                subtitle => 'Enter code below, then click the button to minify or prettify'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.js_minify.content'
                }
            }
        };
};

1;
