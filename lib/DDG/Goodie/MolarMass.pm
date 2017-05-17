package DDG::Goodie::MolarMass;
# ABSTRACT: Calculates the molar mass of a chemical compound from its formula

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'molar_mass';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers start => 'molar mass of';

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

    return 'plain text response',
        structured_answer => {

            data => {
                title    => 'My Instant Answer Title',
                subtitle => 'My Subtitle',
                # image => 'http://website.com/image.png',
            },

            templates => {
                group => 'text',
                # options => {
                #
                # }
            }
        };
};

1;
