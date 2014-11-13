package DDG::Goodie::IsAwesome::tarun29061990;
# ABSTRACT: tarun29061990's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_tarun29061990";
zci is_cached   => 1;

name "IsAwesome tarun29061990";
description "My first Goodie, it let's the world know that tarun29061990 is awesome";
primary_example_queries "duckduckhack tarun29061990";
category "entertainment";
topics "entertainment", "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/tarun29061990.pm";
attribution github => ["https://github.com/tarun29061990", "tarun29061990"],
            twitter => "_tarunChaudhary";

triggers start => "duckduckhack tarun29061990";

handle remainder => sub {
    return if $_;
    return "tarun29061990 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
