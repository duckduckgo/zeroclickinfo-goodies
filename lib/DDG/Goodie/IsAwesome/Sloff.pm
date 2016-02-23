package DDG::Goodie::IsAwesome::Sloff;
# ABSTRACT: Sloff's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_sloff";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack sloff";

# Handle statement
handle remainder => sub {

    # Return undef if there is something after the trigger
    return if $_;

    # Normal return text
    return "Ettienne Pitts is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
    
};

1;
