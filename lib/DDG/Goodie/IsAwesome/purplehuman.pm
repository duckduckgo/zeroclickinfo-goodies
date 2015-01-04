package DDG::Goodie::IsAwesome::purplehuman;
# ABSTRACT: purplehuman's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_purplehuman";
zci is_cached   => 1;

name "IsAwesome purplehuman";
description "My first Goodie, it let's the world know that purplehuman is awesome";
primary_example_queries "duckduckhack purplehuman";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/purplehuman.pm";
attribution github => ["https://github.com/purplehuman", "purplehuman"];

triggers start => "duckduckhack purplehuman";

handle remainder => sub {
    return if $_;
    return "purplehuman is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
