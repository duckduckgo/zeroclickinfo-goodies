package DDG::Goodie::IsAwesome::rp4;
# ABSTRACT: rp4's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_rp4";
zci is_cached   => 1;

name "IsAwesome rp4";
description "My first Goodie, it let's the world know that rp4 is awesome";
primary_example_queries "duckduckhack rp4";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/rp4.pm";
attribution github => ["https://github.com/rp4", "rp4"];

triggers start => "duckduckhack rp4";

handle remainder => sub {
    return if $_;
    return "rp4 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
