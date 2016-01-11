package DDG::Goodie::Bin2Unicode;
# ABSTRACT: Convert binary to unicode 

use DDG::Goodie;
use strict;

use warnings FATAL => 'non_unicode';

zci answer_type => 'bin2unicode';
zci is_cached   => 1;

# Triggers - https://duck.co/duckduckhack/goodie_triggers
triggers query => qr{[ 01]+(?:(?:to\s+)?unicode|text|ascii)?};

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    # Optional - Guard against no remainder
    # I.E. the query is only 'triggerWord' or 'trigger phrase'
    #
    # return unless $remainder;

    # Optional - Regular expression guard
    # Use this approach to ensure the remainder matches a pattern
    # I.E. it only contains letters, or numbers, or contains certain words
    #
    # return unless qr/^\w+|\d{5}$/;

    return "plain text response",
        structured_answer => {

            # ID - Must be unique and match Instant Answer page
            # E.g. https://duck.co/ia/view/calculator has `id => 'calculator'``
            id => 'bin2unicode',

            # Name - Used for Answer Bar Tab
            # Value should be chosen from existing Instant Answer topics
            # see https://duck.co/duckduckhack/display_reference#codenamecode-emstringem-required
            name => 'Answer',

            data => {
              title => "My Instant Answer Title",
              subtitle => "My Subtitle",
              # image => "http://website.com/image.png"
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
