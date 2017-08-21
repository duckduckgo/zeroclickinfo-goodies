package DDG::Goodie::DownloadTimeCalculator;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'download_time_calculator';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => 'download time calculator', 'dl time calc';

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

    return '', structured_answer => {

            data => {
                title    => 'Download Time Calculator',
                speed => '',
                data => '',
            },
            
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.download_time_calculator.content'
                }
            }
        };
    return;
};

1;
