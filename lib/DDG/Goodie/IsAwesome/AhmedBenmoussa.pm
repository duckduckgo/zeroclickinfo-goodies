package DDG::Goodie::IsAwesome::AhmedBenmoussa;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ahmed_benmoussa";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome AhmedBenmoussa";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/AhmedBenmoussa.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers start => "duckduckhack ahmedbenmoussa";

# Handle statement
handle remainder => sub {
    return if $_;
    return "AhmedBenmoussa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
