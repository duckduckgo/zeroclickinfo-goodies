package DDG::Goodie::IsAwesome::maxau;

# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => 'is_awesome_maxau';

# Caching - https://duck.co/duckduckhack/spice_advanced_backend#caching-api-responses
zci is_cached   => 1;

# Triggers - https://duck.co/duckduckhack/goodie_triggers
triggers start => "duckduckhack maxau";

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
    return if $_;
    return "maxau is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
