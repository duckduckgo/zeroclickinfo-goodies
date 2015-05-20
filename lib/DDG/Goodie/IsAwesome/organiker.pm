package DDG::Goodie::IsAwesome::organiker;
# ABSTRACT: organiker's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_organiker";
zci is_cached   => 1;

name "IsAwesome organiker";
description "My first Goodie, it lets the world know that organiker is awesome";
primary_example_queries "duckduckhack organiker";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/GitHubUsername.pm";
attribution github => ["https://github.com/organiker", "organiker"],
            twitter => "jiyeonorganiker";

triggers start => "duckduckhack organiker";

handle remainder => sub {
    return if $_;
    return "organiker is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
