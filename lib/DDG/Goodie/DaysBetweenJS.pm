package DDG::Goodie::DaysBetweenJS;

# ABSTRACT: this goodie will output amount of days, hours, minutes, seconds between the
# chosen dates

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => 'days_between_js';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers start => 'from';
triggers end => 'years', 'days', 'hours', 'minutes', 'seconds';

# Handle statement
handle query_lc => sub {

    my $query_lc = $_;

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
            id => 'days_between_js',

            # Name - Used for Answer Bar Tab
            # Value should be chosen from existing Instant Answer topics
            # see http://docs.duckduckhack.com/frontend-reference/display-reference.html#name-string-required
            name => 'Answer',

            data => {
              title => "Date Calculator",
              subtitle => "between desired dates",
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
