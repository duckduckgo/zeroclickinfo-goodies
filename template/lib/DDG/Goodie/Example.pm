package DDG::Goodie::<: $ia_package_name :>;

# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => '<: $lia_name :>';
zci is_cached   => 1;

name '<: $lia_name :>';

# Triggers
triggers any => 'triggerWord', 'trigger phrase';

# Handle statement
handle remainder => sub {

    # Optional - Guard against no remainder
    # i.e. the query is only 'triggerWord' or 'trigger phrase'
    #
    # return unless $remainder;

    # Optional - Regular expression guard
    # use this approach to ensure the remainder matches a pattern
    # i.e. it only contains letters, or numbers, or contains certain words
    #
    # return unless qr/^\w+/;

    return "plain text response",
        structured_answer => {
                id => '<: $lia_id :>', # Should be an existing Instant Answer topic
                name => 'Answerbar Tab Name', # Should be an existing Instant Answer topic
                data => { q => $_ },
                templates => 1
            };
    };
};

1;
