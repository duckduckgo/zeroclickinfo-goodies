package DDG::Goodie::IsAwesome::mickeypash;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mickeypash";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome mickeypash";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/mickeypash.pm";
attribution github => ["mickeypash", "Mickey Pash"],
            twitter => "mickeypash";

# Triggers
triggers start => "duckduckhack mickeypash";

# Handle statement
handle remainder => sub {
    return if $_;
    return "mickeypash is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
