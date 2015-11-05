package DDG::Goodie::Life;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "life";
zci is_cached   => 1;

name "Life";

# Triggers
triggers any => "life", "conway's game of life";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;

    #return unless $_; # Guard against "no answer"

    # return $_;

    return "Conway's Game of Life",
        structured_answer => {
                id => 'life',
                name => 'Games',
                data => { q => $_ },
                templates => 1              
        };

};

1;
