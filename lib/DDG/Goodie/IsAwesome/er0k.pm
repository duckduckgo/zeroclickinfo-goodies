package DDG::Goodie::IsAwesome::er0k;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_er0k";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome er0k";
description "wtf is this?";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/er0k.pm";
attribution github => ["https://github.com/er0k", "er0k"],
            twitter => "er0k";

# Triggers
triggers any => "duckduckhack er0k";

# Handle statement
handle remainder => sub {
    return if $_;
    return "fart fart fart";
};

1;
