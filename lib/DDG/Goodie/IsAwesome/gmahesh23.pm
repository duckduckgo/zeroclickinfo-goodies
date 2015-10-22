package DDG::Goodie::IsAwesome::gmahesh23;
# ABSTRACT: gmahesh23's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gmahesh23";
zci is_cached   => 1;

name "IsAwesome gmahesh23";
description "Tell the world gmahesh23 is awesome ";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/gmahesh23.pm";
attribution github => ["https://github.com/gmahesh23", "gmahesh23"],
            twitter => "gmahesh1994";

triggers any => "duckduckhack gmahesh23";

handle remainder => sub {
    return if $_;
    return "gmahesh23 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
