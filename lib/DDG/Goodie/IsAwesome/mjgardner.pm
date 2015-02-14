package DDG::Goodie::IsAwesome::mjgardner;
# ABSTRACT: mjgardner's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_mjgardner";
zci is_cached   => 1;

name "IsAwesome mjgardner";
description "My first Goodie, it let's the world know that mjgardner is awesome";
primary_example_queries "duckduckhack mjgardner";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/mjgardner.pm";
attribution github => ["https://github.com/mjgardner", "mjgardner"],
            twitter => "markjgardner";

triggers start => "duckduckhack mjgardner";

handle remainder => sub {
    return if $_;
    return "mjgardner is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
