package DDG::Goodie::IsAwesome::zhou;
# ABSTRACT: zhou's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_zhou";
zci is_cached   => 1;

name "IsAwesome zhou";
description "My first Goodie, it let's the world know that zhou is awesome";
primary_example_queries "duckduckhack zhou";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/zhou.pm";
attribution github => ["https://github.com/zhou", "Jerry Zhou"];

triggers start => "duckduckhack zhou";

handle remainder => sub {
    return if $_;
    return "zhou is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};


1;
