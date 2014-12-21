package DDG::Goodie::IsAwesome::mogigoma;
# ABSTRACT: Mogigoma's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_mogigoma";
zci is_cached   => 1;

name "IsAwesome mogigoma";
description "My first Goodie, it let's the world know that Mogigoma is awesome";
primary_example_queries "duckduckhack mogigoma";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/mogigoma.pm";
attribution github => ["https://github.com/mogigoma", "mogigoma"],
            twitter => "mogigoma";

triggers start => "duckduckhack mogigoma";

handle remainder => sub {
    return if $_;
    return "Mogigoma is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
