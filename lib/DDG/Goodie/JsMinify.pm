package DDG::Goodie::JsMinify;
# ABSTRACT: An Interactive JavaScript Minifier Tool

use DDG::Goodie;
use strict;

zci answer_type => 'jsminify';
zci is_cached => 1;

triggers startend => share('triggers.txt')->slurp;
# triggers startend => 'js minify', 'js minifier', 'javascript minify', 'javascript minifier', 'minify js', 'minify javascript', 'minifier js', 'minifier javascript';

handle remainder => sub {

    return if $_;

    return '',
        structured_answer => {

            id => "js_minify",

            data => {},

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
