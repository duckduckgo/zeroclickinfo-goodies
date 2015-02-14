package DDG::Goodie::IsAwesome::19kestier;
# ABSTRACT: 19kestier's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_19kestier";
zci is_cached   => 1;

name "IsAwesome 19kestier";
description "My first Goodie, it let's the world know that 19kestier is awesome";
primary_example_queries "duckduckhack 19kestier";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/19kestier.pm";
attribution github => ["https://github.com/19kestier", "19kestier"],
            twitter => "kestier19";

triggers start => "duckduckhack 19kestier";

handle remainder => sub {
    return if $_;
    return "19kestier is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
