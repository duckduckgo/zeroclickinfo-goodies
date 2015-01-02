package DDG::Goodie::IsAwesome::claytonspinner;
# ABSTRACT: claytonspinner's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_claytonspinner";
zci is_cached   => 1;

name "IsAwesome claytonspinner";
description "My first Goodie, it let's the world know that claytonspinner is awesome";
primary_example_queries "duckduckhack claytonspinner";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/claytonspinner.pm";
attribution github => ["https://github.com/claytonspinner", "claytonspinner"];

triggers start => "duckduckhack claytonspinner";

handle remainder => sub {
    return if $_;
    return "claytonspinner is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
