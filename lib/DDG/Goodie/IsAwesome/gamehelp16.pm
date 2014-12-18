package DDG::Goodie::IsAwesome::gamehelp16;
# ABSTRACT: gamehelp16's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_gamehelp16";
zci is_cached   => 1;

name "IsAwesome gamehelp16";
description "My first Goodie, it let's the world know that gamehelp16 is awesome";
primary_example_queries "duckduckhack gamehelp16";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/gamehelp16.pm";
attribution github => ["https://github.com/gamehelp16", "gamehelp16"],
            twitter => "gamehelp16";

triggers start => "duckduckhack gamehelp16";

handle remainder => sub {
    return if $_;
    return "gamehelp16 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
