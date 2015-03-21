package DDG::Goodie::IsAwesome::jgkamat;
# ABSTRACT: jgkamat's first Goodie

use strict;
use DDG::Goodie;

zci answer_type => "is_awesome_jgkamat";
zci is_cached   => 1;

name "IsAwesome jgkamat";
description "My first Goodie, it lets the world know that jgkamat is awesome";
primary_example_queries "duckduckhack jgkamat";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jgkamat.pm";
attribution github => ["https://github.com/jgkamat", "jgkamat"],
            twitter => "onion_chesse";

# Triggers
triggers start => "duckduckhack jgkamat";

# Handle statement
handle remainder => sub {
    return if $_;
    return "jgkamat is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
