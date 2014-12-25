package DDG::Goodie::IsAwesome::isleofmax;
# ABSTRACT: isleofmax's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_isleofmax";
zci is_cached   => 1;

name "IsAwesome isleofmax";
description "My first Goodie, it let's the world know that isleofmax is awesome";
primary_example_queries "duckduckhack isleofmax";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/isleofmax.pm";
attribution github => ["https://github.com/isleofmax", "isleofmax"];

triggers start => "duckduckhack isleofmax";

handle remainder => sub {
    return if $_;
    return "isleofmax is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
