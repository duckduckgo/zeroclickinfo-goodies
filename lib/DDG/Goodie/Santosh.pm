package DDG::Goodie::Santosh;

# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => 'santosh';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => 'triggerword', 'trigger phrase';

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
            id => 'santosh',

            # Name - Used for Answer Bar Tab
            # Value should be chosen from existing Instant Answer topics
            # see http://docs.duckduckhack.com/frontend-reference/display-reference.html#name-string-required
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
