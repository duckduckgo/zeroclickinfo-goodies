package DDG::Goodie::IsAwesome::Quoidautre;
#ABSTRACT: Quoidautre's first Goodie;

use DDG::Goodie;
use strict;

zci answer_type => "quoidautre";
zci is_cached   => 1;

name "IsAwesome Quoidautre";
description "My first Goodie, it lets the world know Quoidautre is awesome";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Quoidautre.pm";
attribution github => ["https://github.com/quoidautre", "quoidautre"],
            twitter => "quoidautre_test";

triggers start => "duckduckhack quoidautre";

handle remainder => sub {
    return if $_;
    return "Quoidautre is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
