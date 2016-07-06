package DDG::Goodie::JsMinify;
# ABSTRACT: An Interactive JavaScript Minifier Tool

use DDG::Goodie;
use strict;

zci answer_type => 'jsminify';
zci is_cached => 1;

triggers any => 'js minify', 'js minifier', 'javascript minify', 'javascript minifier', 'minify js', 'minify javascript', 'minifier js', 'minifier javascript';

handle query_lc => sub {

    return unless $_;

    return '',
        structured_answer => {

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
