package DDG::Goodie::IsAwesome::roshanr95;
# ABSTRACT: roshanr95's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_roshanr95";
zci is_cached   => 1;

name "IsAwesome roshanr95";
description "My first Goodie, it let's the world know that roshanr95 is awesome";
primary_example_queries "duckduckhack roshanr95";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/roshanr95.pm";
attribution github => ["roshanr95", "Roshan"],
            twitter => "roshanr95";

triggers start => "duckduckhack roshanr95";

handle remainder => sub {
    return if $_;
    return "roshanr95 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;

