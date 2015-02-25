package DDG::Goodie::IsAwesome::NicolasGeraud;
# ABSTRACT: NicolasGeraud's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_nicolas_geraud";
zci is_cached   => 1;

name "IsAwesome NicolasGeraud";
description "My first Goodie, it let's the world know that Nicolas Géraud is awesome";
primary_example_queries "duckduckhack NicolasGeraud";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/NicolasGeraud.pm";
attribution github => ["https://github.com/NicolasGeraud", "NicolasGeraud"],
            twitter => "NicolasGeraud";

triggers start => "duckduckhack nicolasgeraud";

handle remainder => sub {
    return if $_;
    return "NicolasGeraud is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
