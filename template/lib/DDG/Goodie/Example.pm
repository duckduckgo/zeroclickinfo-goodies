package DDG::Goodie::<: $ia_package_name :>;

# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => '<: $ia_id :>';

# Caching - https://duck.co/duckduckhack/spice_advanced_backend#caching-api-responses
zci is_cached   => 1;

# Triggers - https://duck.co/duckduckhack/goodie_triggers
triggers any => 'triggerWord', 'trigger phrase';

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
            id => '<: $ia_id :>',

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
