package DDG::Goodie::IsAwesome::jmvbxx;
# ABSTRACT: jmvbxx's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_jmvbxx";
zci is_cached   => 1;

name "IsAwesome jmvbxx";
description "My first Goodie, it let's the world know that jmvbxx is awesome";
primary_example_queries "duckduckhack jmvbxx";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jmvbxx.pm";
attribution github => ["https://github.com/jmvbxx", "jmvbxx"];

triggers start => "duckduckhack jmvbxx";

handle remainder => sub {
    return if $_;
    return "jmvbxx is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;