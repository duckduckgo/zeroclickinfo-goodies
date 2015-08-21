package DDG::Goodie::IsAwesome::AhmedBenmoussa;

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ahmed_benmoussa";
zci is_cached   => 1;

name "IsAwesome AhmedBenmoussa";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";


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
