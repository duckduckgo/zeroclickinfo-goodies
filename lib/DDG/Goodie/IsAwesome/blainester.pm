package DDG::Goodie::IsAwesome::blainester;
# ABSTRACT: blainester's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_blainester";
zci is_cached   => 1;

name "IsAwesome blainester";
description "My first Goodie, it lets the world know that blainester is awesome";
primary_example_queries "duckduckhack blainester";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/blainester.pm";
attribution github => ["https://github.com/blainester", "blainester"],
            twitter => "blaine_story";

triggers start => "duckduckhack blainester";

handle remainder => sub {
    return if $_;
    return "blainester is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
