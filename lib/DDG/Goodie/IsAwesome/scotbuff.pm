package DDG::Goodie::IsAwesome::scotbuff;
# ABSTRACT: scotbuff's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_scotbuff";
zci is_cached   => 1;

name "IsAwesome scotbuff";
description "My first Goodie, it let's the world know that scotbuff is awesome";
primary_example_queries "duckduckhack scotbuff";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/scotbuff.pm";
attribution github => ["https://github.com/scotbuff", "scotbuff"],
            twitter => "scotbuff";

triggers start => "duckduckhack scotbuff";
handle remainder => sub {
    return if $_;
    return "scotbuff is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
