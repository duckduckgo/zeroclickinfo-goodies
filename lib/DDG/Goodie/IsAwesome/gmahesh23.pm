package DDG::Goodie::IsAwesome::gmahesh23;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gmahesh23";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome gmahesh23";
description "Tell the world gmahesh23 is awesome ";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/gmahesh23.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "gmahesh1994";

# Triggers
triggers any => "duckduckhack gmahesh23";

# Handle statement
handle remainder => sub {
    return if $_;
    return "gmahesh23 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
