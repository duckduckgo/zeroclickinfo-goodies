package DDG::Goodie::IfYouCould;
# ABSTRACT: If you could hack your search engine, what would you do?

use DDG::Goodie;
use strict;

zci answer_type => 'if_you_could';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 0;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any =>
    'if you could hack your search engine',
    'if you could hack your search engine, what would you do';

# Handle statement
handle remainder => sub {

    # Guard against remainder
    # i.e. we want the query to be only 'trigger text', or a question
    #
    return unless ($_ eq '' || $_ eq '?');

    my $answer = 'This DuckDuckHack.';
 
    return $answer,
        structured_answer => {
            id        => 'if_you_could',
            # name      => 'IfYouCould',
            data      => {
                title      => $answer,
                subtitle   => 'If you could hack your search engine, what would you do?'
            },
            meta      => {
                sourceName => 'DuckDuckHack',
                sourceUrl => 'https://duck.co'
            },
            templates => {
                group      => 'text'
            }
     };
};

1;