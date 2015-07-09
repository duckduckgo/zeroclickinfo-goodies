package DDG::Goodie::IsAwesome::mcavallaro;
# ABSTRACT: mcavallaro's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mcavallaro";
zci is_cached   => 1;

name "IsAwesome mcavallaro";
description "My first Goodie, let the world know how I spent the last hour";
primary_example_queries "duckduckhack mcavallaro";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/mcavallaro.pm";
attribution github => ["https://github.com/mcavallaro", "mcavallaro"] ;

triggers start => "duckduckhack mcavallaro";

handle remainder => sub {
    return if $_;
    return "mcavallaro is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
