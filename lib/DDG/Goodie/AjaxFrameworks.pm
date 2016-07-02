package DDG::Goodie::AjaxFrameworks;
# ABSTRACT: Return a list of Ajax frameworks for a given language

use DDG::Goodie;
use strict;

use YAML::XS 'LoadFile';

zci answer_type => 'ajax_frameworks';
zci is_cached => 1;

triggers any => 'ajax', 'ajax framework', 'ajax frameworks';

my $DATA = LoadFile(share('frameworks.yml'));

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    return unless $remainder;

#     if ($remainder !=~ /(javascript|js|perl|php|python|java|ruby)/i)

    return "plain text response",
        structured_answer => {

            data => {
                title    => "My Instant Answer Title",
                subtitle => "My Subtitle",
                # image => "http://website.com/image.png",
            },

            templates => {
                group => "text",
                # options => {
                #
                # }
            }
        };
};

1;
