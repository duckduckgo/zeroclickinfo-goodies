package DDG::Goodie::HtmlBeautifier;
# ABSTRACT: A Goodie to beautify HTML tags.
use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'htmlbeautifier';
zci is_cached => 1;

triggers startend => share('triggers.txt')->slurp;

handle remainder => sub {

    # Return unless the remainder is empty or contains online or tool
    return unless ( $_ =~ /(^$|online|tool|code|utility)/i );

    return '',
        structured_answer => {

            id => "html_beautifier",

            data => {
                title => 'HTML Beautifier',
                subtitle => 'Reformat HTML code by adding proper indentation.'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.html_beautifier.content'
                }
            }
        };
};

1;
