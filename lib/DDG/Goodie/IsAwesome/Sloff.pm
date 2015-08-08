package DDG::Goodie::IsAwesome::Sloff;
# ABSTRACT: Sloff's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_sloff";
zci is_cached   => 1;

name "IsAwesome Sloff";
description "My first goodie";
primary_example_queries "duckduckhack sloff";
category "special";
topics "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Sloff.pm";
attribution github => ["https://github.com/Sloff/", "Sloff"];

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
