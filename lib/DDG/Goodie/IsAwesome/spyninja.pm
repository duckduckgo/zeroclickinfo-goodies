package DDG::Goodie::IsAwesome::spyninja;
# ABSTRACT: spyninja's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_spyninja";
zci is_cached   => 1;

name "IsAwesome spyninja";
description "My first Goodie, it let's the world know that spyninja is awesome";
primary_example_queries "duckduckhack spyninja";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/spyninja.pm";
attribution github => ["https://github.com/spyninja", "spyninja"];

triggers start => "duckduckhack spyninja";

handle remainder => sub {
    return if $_;
    return "spyninja is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
