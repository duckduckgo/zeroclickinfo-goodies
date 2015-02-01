package DDG::Goodie::IsAwesome::ag8;
# ABSTRACT: ag8's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_ag8";
zci is_cached   => 1;

name "IsAwesome ag8";
description "My first Goodie, it let's the world know that ag8 is awesome";
primary_example_queries "duckduckhack ag8";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ag8.pm";
attribution github => ["https://github.com/ag8", "ag8"],
            twitter => "";

triggers start => "duckduckhack ag8";

handle remainder => sub {
    return if $_;
    return "ag8 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
