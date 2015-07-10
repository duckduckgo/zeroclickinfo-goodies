package DDG::Goodie::IsAwesome::Sloff;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_sloff";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome Sloff";
description "My first goodie";
primary_example_queries "duckduckhack sloff";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "special";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
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
