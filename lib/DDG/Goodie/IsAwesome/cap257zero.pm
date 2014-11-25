package DDG::Goodie::IsAwesome::cap257zero;
# ABSTRACT: cap257zero's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_cap257zero";
zci is_cached   => 1;

name "IsAwesome cap257zero";
description "My first Goodie, it let's the world know that cap257zero is awesome";
primary_example_queries "duckduckhack cap257zero";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/cap257zero.pm";
attribution github => ["https://github.com/cap257zero", "cap257zero"];

triggers start => "duckduckhack cap257zero";

handle remainder => sub {
    return if $_;
    return "cap257zero is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
